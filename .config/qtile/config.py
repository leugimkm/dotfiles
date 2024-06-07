import subprocess
from os import path

from libqtile import hook

from widgets import extension_defaults
from layouts import floating_layout, layouts
from inputs import groups, keys, mouse
from screens import screens


@hook.subscribe.startup
def autostart():
    subprocess.run([path.expanduser('~/.config/qtile/autostart.sh')])


keys, groups, layouts, mouse = keys, groups, layouts, mouse
extension_defaults, floating_layout = extension_defaults, floating_layout
screens = screens
dgroups_key_binder, dgroups_app_rules=  None, []
follow_mouse_focus, bring_front_click, floats_kept_above = True, False, True
cursor_warp, auto_fullscreen = False, True
reconfigure_screens, auto_minimize = True, True
focus_on_window_activation = "smart"
wmname = "Qtile"
