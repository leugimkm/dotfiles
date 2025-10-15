local wezterm = require "wezterm"
-- local mux = wezterm.mux
-- local act = wezterm.action
local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.font = wezterm.font("SauceCodePro NFM")
config.font_size = 12
config.color_scheme = "Solarized Dark - Patched"
config.colors = {
  background = "#031219"
}
config.enable_tab_bar = false
config.defaul_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color"
config.audible_bell = "Disabled"
config.window_background_opacity = 0.95
return config

