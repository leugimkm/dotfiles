local wezterm = require "wezterm"
-- local mux = wezterm.mux
-- local act = wezterm.action
local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.font = wezterm.font("SauceCodePro NFM")
config.enable_tab_bar = false
config.term = "xterm-256color"
config.color_scheme = "Gruvbox Dark (Gogh)"
config.window_background_opacity = 0.95
config.font_size = 11

return config

