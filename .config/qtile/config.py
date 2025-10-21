from libqtile import bar
from libqtile.config import Screen

from setup import keys, mouse, groups, layouts, floating_layout
from widgets import widgets,widget_defaults, extension_defaults

screens = [
    Screen(
        top=bar.Bar(
            widgets,
            background="#28282840",
            size=24,
            opacity=0.95,
            margin=[8, 8, 4, 8],  # [N, E, S, W]
        ),
    ),
]

dgroups_key_binder = None
dgroups_app_rules: list = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
