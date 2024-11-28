import os
import subprocess
from random import choice

from libqtile import bar, layout, hook, widget
from libqtile.config import EzClick as Click, EzDrag as Drag, EzKey as Key
from libqtile.config import Group, Match, Screen, EzKeyChord as KeyChord
from libqtile.config import ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from custom import Center, Deco
from consts import SYMBOLS as S, THEME

C = THEME["ayu"]


@hook.subscribe.startup
def autostart():
    subprocess.run([os.path.expanduser('~/.config/qtile/autostart.sh')])


@lazy.function
def minimize(qtile):
    for w in qtile.current_group.windows:
        if hasattr(w, "toggle_minimize"):
            w.toggle_minimize()


def set_wallpaper():
    dir_ = os.path.expanduser('~/pictures/wallpapers')
    return os.path.join(dir_, choice(os.listdir(dir_)))


keys = [
    Key(("M-A-h"), lazy.layout.left()),
    Key(("M-A-l"), lazy.layout.right()),
    Key(("M-A-j"), lazy.layout.down()),
    Key(("M-A-k"), lazy.layout.up()),
    Key(("M-j"), lazy.group.next_window(), lazy.window.bring_to_front()),
    Key(("M-k"), lazy.group.prev_window(), lazy.window.bring_to_front()),
    Key(("M-<space>"), lazy.widget["keyboardlayout"].next_keyboard()),
    Key(("M-S-h"), lazy.layout.shuffle_left()),
    Key(("M-S-l"), lazy.layout.shuffle_right()),
    Key(("M-S-j"), lazy.layout.shuffle_down()),
    Key(("M-S-k"), lazy.layout.shuffle_up()),
    Key(("M-C-h"), lazy.layout.grow_left()),
    Key(("M-C-l"), lazy.layout.grow_right()),
    Key(("M-C-j"), lazy.layout.grow_down()),
    Key(("M-C-k"), lazy.layout.grow_up()),
    Key(("M-n"), lazy.layout.normalize()),
    Key(("M-S-<Return>"), lazy.layout.toggle_split()),
    Key(("M-<Return>"), lazy.spawn(guess_terminal())),
    Key(("M-<Tab>"), lazy.next_layout()),
    Key(("M-w"), lazy.window.kill()),
    Key(("M-f"), lazy.window.toggle_fullscreen(), lazy.hide_show_bar()),
    Key(("M-b"), lazy.hide_show_bar()),
    Key(("M-t"), lazy.window.toggle_floating()),
    Key(("M-C-r"), lazy.reload_config()),
    Key(("M-C-q"), lazy.shutdown()),
    Key(("M-r"), lazy.spawncmd()),
    Key(("M-C-m"), minimize()),
    KeyChord(("M-p"), [
        Key(("f"), lazy.spawn("firefox")),
        Key(("q"), lazy.spawn("qutebrowser")),
        Key(("r"), lazy.spawn("rofi -show drun")),
        Key(("1"), lazy.group["scratchpad"].dropdown_toggle("term")),
    ]),
]

groups = [
    Group(f"{i}", label=label, layout=layout)
    for i, (label, layout) in enumerate([
        (S["1"], 'monadtall'), (S["2"], 'monadthreecol'), (S["3"], 'monadwide'),
        (S["4"], 'plasma'), (S["5"], 'monadtall'), (S["6"], 'max'),
    ], 1)
]

for g in groups:
    keys.extend([
        Key(f"M-{g.name}", lazy.group[g.name].toscreen()),
        Key(f"M-S-{g.name}", lazy.window.togroup(g.name, switch_group=True)),
    ])

groups.append(
    ScratchPad("scratchpad", [
        DropDown("term", "kitty", width=0.4, x=0.3, y=0.2),
    ])
)

mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]

layout_theme = {
    "border_width": 2, "margin": 8,
    "border_normal": C["background"], "border_focus": C["color11"],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadThreeCol(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Plasma(**layout_theme),
    Center(**layout_theme),
    layout.Max(**layout_theme),
]

widget_defaults = dict(
    font="SauceCodePro NF", fontsize=12, padding=0, background=C["background"],
)
extension_defaults = widget_defaults.copy()

widgets = [
    widget.Image(
        filename="~/pictures/logos/logo_custom.png",
        scale="False",
        background="#00000000",
        margin=4,
    ),
    Deco(C["selection_background"], "#00000000"),
    widget.TextBox(
        text="ayudaenpython.com",
        foreground=C["foreground"],
        background=C["selection_background"],
    ),
    Deco(C["color12"], C["selection_background"]),
    Deco(C["color9"], C["color12"]),
    Deco(C["color11"], C["color9"]),
    Deco(C["selection_background"], C["color11"]),
    widget.GroupBox(
        highlight_color=["000000", "282828"],
        highlight_method="line",
        active=C["foreground"],
        this_current_screen_border=C["color11"],
    ),
    Deco(C["background"], "#00000000", side="R"),
    widget.Prompt(
        prompt="> ",
        foreground=C["foreground"],
        background="#00000000",
    ),
    widget.WindowName(
        foreground=C["foreground"],
        background="#00000000",
        format='{name}'
    ),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
            "vim mode": ("#2980b9", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Systray(),
    Deco(C["selection_background"], "#00000000"),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[os.path.expanduser("~/pictures/icons")],
        padding=2, scale=0.5,
        foreground=C["color11"],
        background=C["selection_background"],
    ),
    widget.CurrentLayout(
        foreground=C["color11"],
        background=C["selection_background"]
    ),
    Deco(C["background"], C["selection_background"]),
    widget.KeyboardLayout(
        configured_keyboards=["us", "es"],
        foreground=C["color10"],
        background=C["background"],
    ),
    Deco(C["selection_background"], C["background"]),
    widget.Clock(
        format="%d/%m/%Y %a %I:%M %p",
        foreground=C["color12"],
        background=C["selection_background"],
    ),
    Deco(C["background"], C["selection_background"]),
    widget.QuickExit(
        default_text="exit",
        foreground=C["color9"],
        background=C["background"],
    ),
    Deco(C["background"], "#00000000", side="R"),
]

screens = [
    Screen(
        wallpaper=set_wallpaper(), wallpaper_mode="fill",
        top=bar.Bar(
            widgets, background="#28282840",
            size=24, opacity=0.95, margin=[4, 4, 2, 4],  # [N, E, S, W]
        ),
    ),
]

dgroups_key_binder = None
dgroups_app_rules: list = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"

