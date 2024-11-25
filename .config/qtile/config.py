import subprocess
from os import path

from libqtile import hook

from widgets import extension_defaults, widget_defaults
from layouts import layouts, floating_layout
from inputs import groups, keys, mouse
from screens import screens


@hook.subscribe.startup
def autostart():
    subprocess.run([path.expanduser('~/.config/qtile/autostart.sh')])


keys, groups, layouts, mouse = keys, groups, layouts, mouse
widget_defaults, extension_defaults = widget_defaults, extension_defaults
floating_layout, screens = floating_layout, screens
dgroups_app_rules = []
dgroups_key_binder = None
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "Qtile"

