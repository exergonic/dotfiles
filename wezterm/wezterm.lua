local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'GruvboxDark'
config.window_background_opacity = 1.00

-- Fonts Settings
-- Font Family: Primary font for terminal text. Supports fallback fonts separated by commas.
config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')

-- Font Size: Font size in points.
config.font_size = 12

-- Line Height: Line height multiplier. 1.0 is the default.
config.line_height = 1.2

-- Window Settings
-- Close Confirmation: Whether to prompt before closing a window with multiple tabs.
config.window_close_confirmation = "NeverPrompt"

-- Initial Columns: Initial number of columns for new windows.
config.initial_cols = 180

-- Initial Rows: Initial number of rows for new windows.
config.initial_rows = 40

-- System Backdrop (Windows): Windows 11 system backdrop style.
config.win32_system_backdrop = "Tabbed"

-- Cursor Settings
-- Cursor Style: The shape and behavior of the cursor.
config.default_cursor_style = "BlinkingUnderline"


-- Gpu Settings
-- Max FPS: Maximum frames per second for rendering.
config.max_fps = 144

-- General Settings
-- Scrollback Lines: Number of lines to keep in scrollback buffer.
config.scrollback_lines = 20500

-- Enable Scroll Bar: Show a scroll bar on the right side.
config.enable_scroll_bar = true

-- Audible Bell: Play a sound when the terminal bell is triggered.
config.audible_bell = "Disabled"



config.default_domain = 'local'
-- config.default_prog = { 'pwsh.exe', '-NoLogo' }
config.default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe', '--login', '-i' }

config.launch_menu = {
  {
    label = 'Git Bash',
    args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '--login', '-i'},
  },
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
    label = 'MSYS2 Environment',
    args = { 'C:\\msys64\\msys2_shell.cmd', '-defterm', '-no-start', '-ucrt64' },
  },
}

return config
