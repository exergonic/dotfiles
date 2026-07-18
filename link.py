#!/usr/bin/env python3
"""Check and create symlinks from dotfiles repo to filesystem locations."""

from __future__ import annotations

import argparse
import base64
import filecmp
import io
import os
import platform
import shutil
import subprocess
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")
from datetime import datetime
from enum import Enum, auto
from pathlib import Path
from typing import Callable


class Status(Enum):
    OK = auto()
    MISSING = auto()
    WRONG_TARGET = auto()
    STALE_COPY = auto()
    STALE_DIFF = auto()
    ELEVATION_NEEDED = auto()
    COVERED = auto()
    ERROR = auto()


REPO = Path(__file__).resolve().parent


def _wt_settings() -> Path | None:
    """Resolve Windows Terminal settings.json (Store version)."""
    packages = Path.home() / "AppData/Local/Packages"
    if not packages.is_dir():
        return None
    for entry in sorted(packages.iterdir()):
        if entry.name.startswith("Microsoft.WindowsTerminal"):
            target = entry / "LocalState/settings.json"
            if target.parent.is_dir():
                return target
    return None


LinkTarget = str | Callable[[], Path | None]

LINKS: list[tuple[str, LinkTarget, list[str]]] = [
    # ── Cross-platform (checked everywhere) ──────────────────────
    ("bash/bashrc",                    "~/.bashrc",                     ["all"]),
    ("bash/inputrc",                   "~/.inputrc",                    ["all"]),
    ("zsh/zshrc",                      "~/.zshrc",                      ["all"]),
    ("zsh/zprofile",                   "~/.zprofile",                   ["all"]),
    ("wezterm/.wezterm.lua",           "~/.wezterm.lua",                ["all"]),
    ("tmux/tmux.conf",                 "~/.tmux.conf",                  ["all"]),
    ("npmrc",                          "~/.npmrc",                      ["all"]),
    ("python_startup.py",              "~/.python_startup.py",          ["all"]),
    ("emacs/init.el",                  "~/.emacs.d/init.el",            ["all"]),
    ("emacs/spacemacs",                "~/.spacemacs",                  ["all"]),
    ("emacs/_emacs",                   "~/.emacs",                      ["all"]),
    # ── Windows only -----------------------------------------------
    ("helix",                          "~/AppData/Roaming/helix",       ["windows"]),
    ("nvim",                           "~/AppData/Local/nvim",          ["windows"]),
    ("Zellij",                         "~/AppData/Roaming/Zellij",      ["windows"]),
    ("terminal/settings.json",         _wt_settings,                    ["windows"]),
    ("powershell/Microsoft.PowerShell_profile.ps1",
                                       "~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1",
                                                                        ["windows"]),
    # ── Linux-only ──────────────────────────────────────────────
    ("nvim",                           "~/.config/nvim",                ["linux"]),

    # ── macOS-only ──────────────────────────────────────────────
    ("nvim",                           "~/.config/nvim",                ["darwin"]),
]


def expand(path: str) -> Path:
    return Path(os.path.expanduser(path))


def resolve_target(entry: LinkTarget) -> Path | None:
    if callable(entry):
        return entry()
    return expand(entry)


def _parent_is_repo_link(target: Path) -> str | None:
    """If any parent dir of target is a symlink into the repo, return the source_rel."""
    real_repo = os.path.realpath(str(REPO)).lstrip("\\").lstrip("?").lstrip("\\")
    for parent in target.parents:
        if os.path.islink(str(parent)):
            link_dest = os.readlink(str(parent))
            if not os.path.isabs(link_dest):
                link_path = os.path.join(str(parent.parent), link_dest)
            else:
                link_path = link_dest
            real_link = os.path.realpath(link_path).lstrip("\\").lstrip("?").lstrip("\\")
            if real_link.startswith(real_repo):
                # Return the relative path inside the repo that this parent covers
                return os.path.relpath(real_link, real_repo).replace("\\", "/")
    return None


def get_status(source: Path, target: Path) -> Status:
    # Check if a parent directory is already a symlink into the repo
    covered_by = _parent_is_repo_link(target)
    if covered_by:
        return Status.COVERED

    # Check symlink first (must check before exists(), which follows links)
    is_link = os.path.islink(str(target))
    if is_link:
        link_dest = os.readlink(str(target))
        if not os.path.isabs(link_dest):
            link_path = os.path.join(str(target.parent), link_dest)
        else:
            link_path = link_dest
        # Normalize to remove \\?\ prefix on Windows
        real_link = os.path.realpath(link_path).lstrip("\\").lstrip("?").lstrip("\\")
        real_src = os.path.realpath(str(source)).lstrip("\\").lstrip("?").lstrip("\\")
        if Path(real_link) == Path(real_src):
            return Status.OK
        return Status.WRONG_TARGET

    if not target.exists():
        return Status.MISSING

    # Plain file — check if content matches
    try:
        if filecmp.cmp(source, target, shallow=False):
            return Status.STALE_COPY
        return Status.STALE_DIFF
    except OSError:
        return Status.ERROR


STYLE = {
    Status.OK:             ("\033[92m",  "OK"),
    Status.MISSING:        ("\033[91m",  "MISSING"),
    Status.WRONG_TARGET:   ("\033[93m",  "WRONG"),
    Status.STALE_COPY:     ("\033[93m",  "STALE copy"),
    Status.STALE_DIFF:     ("\033[93m",  "STALE diff"),
    Status.ELEVATION_NEEDED: ("\033[94m", "ELEVATE"),
    Status.COVERED:        ("\033[94m",  "COVERED"),
    Status.ERROR:          ("\033[91m",  "ERROR"),
}


def check_links(entries: list[tuple[str, LinkTarget, list[str]]],
                platform_ok: str) -> list[tuple[str, Path, Path | None, Status]]:
    results: list[tuple[str, Path, Path | None, Status]] = []
    for source_rel, target_def, _ in entries:
        source = (REPO / source_rel).resolve()
        target = resolve_target(target_def)
        if target is None:
            results.append((source_rel, source, None, Status.ERROR))
            continue
        results.append((source_rel, source, target, get_status(source, target)))
    return results


def print_results(results: list[tuple[str, Path, Path | None, Status]], verbose: bool = False):
    lines = [f"Dotfiles link status - {REPO}", ""]
    header = f" {'Status':>12}  Repo file -> Symlink"
    lines.append(header)
    lines.append("-" * len(header))

    for source_rel, source, target, status in results:
        style_code, label = STYLE[status]
        target_str = str(target) if target else "?"
        if status in (Status.STALE_COPY, Status.STALE_DIFF):
            extra = " (copy)" if status == Status.STALE_COPY else " (diff)"
            label += extra
        elif status == Status.COVERED and target:
            covered_by = _parent_is_repo_link(target)
            if covered_by:
                label += f" ({covered_by})"
        reset = "\033[0m" if sys.stdout.isatty() else ""
        lines.append(f" {style_code}{label:>12}{reset}  {source_rel} -> {target_str} ")

    # Summary
    counts = {s: 0 for s in Status}
    for _, _, _, s in results:
        counts[s] += 1
    lines.append("")
    parts = [f"  {counts[s]}x {STYLE[s][1]}" for s in Status if counts[s] > 0]
    lines.append(" ".join(parts))
    print("\n".join(lines))


def backup_stale(target: Path) -> Path | None:
    """Move an existing file to .backups/ before replacing it."""
    backup_dir = REPO / ".backups" / datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir.mkdir(parents=True, exist_ok=True)
    dest = backup_dir / target.name
    shutil.move(str(target), str(dest))
    return dest


def _is_admin_windows() -> bool:
    try:
        import ctypes
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except Exception:
        return False


def _elevated_symlink_batch(ops: list[tuple[Path, Path]]) -> bool:
    """Run all pending symlink creations in an elevated PowerShell process."""
    tmp = Path(os.environ.get("TEMP", "/tmp")) / f"_dotfiles_link_{os.getpid()}.ps1"
    lines = [
        '$ErrorActionPreference = "Stop"',
    ]
    for source, target in ops:
        parent = str(target.parent)
        src = str(source)
        tgt = str(target)
        lines.append(f'if (!(Test-Path "{parent}")) {{ New-Item -ItemType Directory -Path "{parent}" -Force | Out-Null }}')
        lines.append(f'if (Test-Path "{tgt}") {{ Remove-Item "{tgt}" -Force }}')
        lines.append(f'New-Item -ItemType SymbolicLink -Path "{tgt}" -Target "{src}" -Force')
    lines.append(f'Remove-Item "{tmp}" -Force')
    tmp.write_text("\n".join(lines), encoding="utf-8")

    try:
        result = subprocess.run([
            "powershell", "-NoProfile", "-ExecutionPolicy", "Bypass",
            "-Command",
            f'Start-Process -Verb RunAs -Wait powershell -ArgumentList '
            f'\'-NoProfile -ExecutionPolicy Bypass -File "{tmp}"\'',
        ], capture_output=True, text=True, timeout=120)
        if result.returncode != 0:
            print(f"  Elevation failed: {result.stderr.strip()}")
            return False
        return True
    except subprocess.TimeoutExpired:
        print("  Elevation timed out (UAC may have been dismissed or ignored)")
        return False
    except Exception as e:
        print(f"  Elevation error: {e}")
        return False
    finally:
        if tmp.exists():
            try:
                tmp.unlink()
            except OSError:
                pass


def fix_links(results: list[tuple[str, Path, Path | None, Status]],
              force: bool = False) -> int:
    """Create missing symlinks and fix stale ones."""
    needs_fix = [r for r in results if r[3] in (Status.MISSING, Status.STALE_COPY, Status.STALE_DIFF, Status.WRONG_TARGET)]
    if not needs_fix:
        print("Nothing to fix.")
        return 0

    fixed = 0
    elevated_ops: list[tuple[Path, Path]] = []
    needs_elevation = False

    for source_rel, source, target, status in needs_fix:
        if target is None:
            continue

        print(f"  {target} -> {source_rel}", end="")

        if status == Status.WRONG_TARGET:
            target.unlink()
            print(" (removed wrong symlink)", end="")
        elif status in (Status.STALE_COPY, Status.STALE_DIFF):
            if force or status == Status.STALE_DIFF:
                backup = backup_stale(target)
                print(f" (backed up -> {backup.name})", end="")
            else:
                choice = input(" - file content matches repo, skip? [Y/s] ").strip().lower()
                if choice and choice not in ("n", "no", "overwrite"):
                    print(" -> SKIPPED")
                    continue
                backup = backup_stale(target)
                print(f" (backed up -> {backup.name})", end="")

        # Attempt symlink creation
        target.parent.mkdir(parents=True, exist_ok=True)
        try:
            os.symlink(source, target)
            print(" -> OK")
            fixed += 1
        except OSError:
            elevated_ops.append((source, target))
            needs_elevation = True
            print(" -> needs elevation")
        except Exception as e:
            print(f" -> ERROR: {e}")

    if needs_elevation:
        if platform.system() == "Windows":
            if _is_admin_windows():
                print("\nAlready running as administrator. Retrying symlinks directly...")
                for src, tgt in elevated_ops:
                    try:
                        tgt.parent.mkdir(parents=True, exist_ok=True)
                        if tgt.exists() or tgt.is_symlink():
                            tgt.unlink()
                        os.symlink(src, tgt)
                        fixed += 1
                        print(f"  {src.name} -> OK")
                    except OSError as e:
                        print(f"  {src.name} -> ERROR: {e}")
            else:
                print(f"\n* Launching elevated PowerShell to create {len(elevated_ops)} symlink(s)...")
                if _elevated_symlink_batch(elevated_ops):
                    fixed += len(elevated_ops)
                    print("Done.")
                else:
                    print(f"Failed to create {len(elevated_ops)} symlink(s). Run as Administrator and try again.")
        else:
            print(f"\nRun with sudo: sudo python3 {__file__} --fix")

    return fixed


def main():
    ap = argparse.ArgumentParser(description="Manage dotfiles symlinks")
    ap.add_argument("--fix", action="store_true", help="Create/fix missing or stale symlinks")
    ap.add_argument("--force", action="store_true", help="In --fix mode, overwrite even if content matches")
    args = ap.parse_args()

    current_platform = platform.system().lower()
    if current_platform == "windows":
        platform_ok = "windows"
    elif current_platform == "darwin":
        platform_ok = "darwin"
    else:
        platform_ok = "linux"

    # Filter links for current platform
    active = []
    for source_rel, target_def, platforms in LINKS:
        if "all" in platforms or platform_ok in platforms:
            active.append((source_rel, target_def, platforms))

    results = check_links(active, platform_ok)
    print_results(results)

    if args.fix:
        count = fix_links(results, force=args.force)
        if count > 0:
            print(f"\nCreated/fixed {count} symlink(s). Run again to verify.")
        elif count == 0:
            pass

    # Return exit code: 0 if all OK, 1 if any issues
    exit_code = 0
    for _, _, _, s in results:
        if s != Status.OK:
            exit_code = 1
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
