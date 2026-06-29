local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'GruvboxDark'
config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')
config.font_size = 13.0
config.window_background_opacity = 1.00

config.default_domain = 'local'
config.default_prog = { 'pwsh.exe', '-NoLogo' }

config.launch_menu = {
  {
    label = 'PowerShell',
    args = { 'pwsh.exe', '-NoLogo' },
  },
  {
    label = 'WSL (Linux Ubuntu)',
    args = { 'wsl.exe', '--distribution', 'Ubuntu', '--cd', '~' },
  },
  {
    label = 'WSL (Arch Linux)',
    args = { 'wsl.exe', '--distribution', 'Arch', '--cd', '~' },
  },
  {
    label = 'Git Bash',
    args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '--login', '-i'},
  },
  {
    label = 'MSYS2 Environment',
    args = { 'C:\\msys64\\msys2_shell.cmd', '-defterm', '-no-start', '-ucrt64' },
  },
}

return config
