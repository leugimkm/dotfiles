import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import (
    Click, Drag, Group, Key, Match, Screen, KeyChord, ScratchPad, DropDown
)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])


mod = "mod4"
terminal = guess_terminal()

keys = [
    Key(["control", "shift"], "h", lazy.layout.left()),
    Key(["control", "shift"], "l", lazy.layout.right()),
    Key(["control", "shift"], "j", lazy.layout.down()),
    Key(["control", "shift"], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left(), lazy.layout.shuffle_left().when(layout="columns")),
    Key([mod, "shift"], "l", lazy.layout.swap_right(), lazy.layout.shuffle_right().when(layout="columns")),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.reset()),
    Key([mod], "o", lazy.layout.maximize()),
    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod, "shift"], "space", lazy.layout.flip()),
    Key([mod, "control"], "h", lazy.layout.grow_left().when(layout="columns")),
    Key([mod, "control"], "l", lazy.layout.grow_right().when(layout="columns")),
    Key([mod, "control"], "j", lazy.layout.grow_down().when(layout="columns")),
    Key([mod, "control"], "k", lazy.layout.grow_up().when(layout="columns")),
    Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left().when(layout="columns")),
    Key([mod, "shift", "control"], "l", lazy.layout.swap_column_right().when(layout="columns")),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "j", lazy.group.next_window(), lazy.window.bring_to_front()),
    Key([mod], "k", lazy.group.prev_window(), lazy.window.bring_to_front()),
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard()),
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "b", lazy.hide_show_bar()),
    Key([mod], "w", lazy.window.kill()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "t", lazy.window.toggle_floating()),
    Key([mod, "control"], "r", lazy.reload_config()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
    Key(["control", "shift"], "space", lazy.layout.next()),
]
keys.append(
    KeyChord([mod], "p", [
        Key([], "f", lazy.spawn("firefox")),
        Key([], "q", lazy.spawn("qutebrowser")),
        Key([], "r", lazy.spawn("rofi -show drun")),
        Key([], "t", lazy.group["scratchpad"].dropdown_toggle("term")),
    ], name="M-p")
)

groups = [Group(i) for i in "12345"]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True))
    ])
groups.append(
    ScratchPad("scratchpad", [DropDown("term", terminal, width=0.4, x=0.3, y=0.2)])
)

layouts_defaults = {"margin": 8, "border_width": 0}
layouts = [
    layout.Columns(**layouts_defaults),
    layout.MonadTall(**layouts_defaults),
    layout.MonadWide(**layouts_defaults),
    layout.Max(margin=[170, 328, 170, 328]),
]

widget_defaults = dict(font="SauceCodePro NFM", fontsize=12, padding=3)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(prompt="> "),
                widget.WindowName(),
                widget.Chord(),
                widget.CurrentLayout(mode="icon", scale=0.5),
                widget.KeyboardLayout(configured_keyboards=["us", "es"]),
                widget.WidgetBox(widgets=[
                    widget.Clock(format="%d/%m/%Y %a %H:%M %p"),
                    widget.QuickExit(default_text="[x]", countdown_format="[{}]"),
                ]),
            ],
            size=24,
        ),
        background="#abb8c3",
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_width=0,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
