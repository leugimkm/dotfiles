import subprocess
from os import path

from libqtile import hook

from widgets import widget_defaults, extension_defaults
from layouts import layouts, floating_layout
from inputs import groups, keys, mouse, mod
from screens import screens


@hook.subscribe.startup
def autostart():
    subprocess.run([path.expanduser('~/.config/qtile/autostart.sh')])


mod = mod
keys = keys
groups = groups
layouts = layouts
widget_defaults = widget_defaults
extension_defaults = extension_defaults
screens = screens
mouse = mouse
floating_layout = floating_layout
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "Qtile"
