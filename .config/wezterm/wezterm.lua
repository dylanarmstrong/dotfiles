local wezterm = require('wezterm')

local config = wezterm.config_builder()

-- Colors
local custom = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
custom.tab_bar.background = '#101019'
custom.tab_bar.active_tab.bg_color = '#CBA6F7'
custom.tab_bar.inactive_tab.bg_color = '#181824'
custom.tab_bar.new_tab.bg_color = '#181824'
config.color_schemes = {
  ['cat'] = custom,
}
config.color_scheme = 'cat'

-- Fonts
config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font('Berkeley Mono')
config.font_size = 12

-- Decoration
config.macos_window_background_blur = 20
config.macos_window_background_blur = 20
config.native_macos_fullscreen_mode = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25
config.use_fancy_tab_bar = false
config.window_background_opacity = 1.0
config.window_decorations = 'RESIZE'

-- Cursor
config.cursor_blink_rate = 0
config.default_cursor_style = 'BlinkingBlock'

-- Shell Integration
config.enable_kitty_keyboard = false

-- Scrollback
config.scrollback_lines = 100000

-- Audio Bell
config.audible_bell = 'Disabled'

-- Confirm Window Close
config.window_close_confirmation = 'NeverPrompt'

-- Check for updates via brew
config.check_for_updates = false

return config
