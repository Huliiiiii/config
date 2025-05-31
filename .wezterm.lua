local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- appearance
config.color_scheme = 'Catppuccin Mocha'
config.max_fps = 240

config.use_dead_keys = false
-- cursor
config.default_cursor_style = 'SteadyUnderline'

-- font
config.font = wezterm.font_with_fallback {
  'Cascadia Next SC',
  'CaskaydiaCove Nerd Font',
  'JetBrains Mono',
}
-- config.dpi = 164
-- config.freetype_load_flags = 'NO_HINTING'
-- config.font_size = 10
-- config.line_height = 1.2

config.default_prog = { 'pwsh' }

-- key
config.keys = {
  {
    key = 'W',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

-- window
config.initial_cols = 98
config.initial_rows = 24
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

config.enable_kitty_keyboard = true
config.allow_win32_input_mode = true

return config
