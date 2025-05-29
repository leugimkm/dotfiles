import os
import subprocess
from random import choice

from libqtile import bar, layout, hook, widget
from libqtile.config import EzClick as Click, EzDrag as Drag, EzKey as Key
from libqtile.config import Group, Match, Screen, EzKeyChord as KeyChord
from libqtile.config import ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from custom import Center, Deco, ColorTheme
from consts import SYMBOLS as S, THEME

TERMINAL = guess_terminal()
DIR = os.path.expanduser("~/pictures/wallpapers")
ICONS = os.path.expanduser("~/pictures/icons")
C = ColorTheme(THEME["gruvbox"])
EXTRAS = False
SQUARE = True


@hook.subscribe.startup
def autostart():
    subprocess.run([os.path.expanduser("~/.config/qtile/autostart.sh")])


@lazy.function
def minimize(qtile):
    for w in qtile.current_group.windows:
        if hasattr(w, "toggle_minimize"):
            w.toggle_minimize()


def set_wallpaper():
    return os.path.join(DIR, choice(os.listdir(DIR)))


def AW(color, bg=True, pad=0):
    bg_color = "background" if bg else "selection_background"
    return {
        "foreground": C(f"bright {color}"),
        "background": C(bg_color),
        "padding": pad,
    }


def SW(color, shade=35, pad=8):
    return {
        "foreground": C(f"bright {color}"),
        "background": C(color, shade),
        "padding": pad,
    }


keys = [
    Key(("C-S-h"), lazy.layout.left()),
    Key(("C-S-l"), lazy.layout.right()),
    Key(("C-S-j"), lazy.layout.down()),
    Key(("C-S-k"), lazy.layout.up()),
    Key(("M-j"), lazy.group.next_window(), lazy.window.bring_to_front()),
    Key(("M-k"), lazy.group.prev_window(), lazy.window.bring_to_front()),
    Key(("M-<space>"), lazy.widget["keyboardlayout"].next_keyboard()),
    Key(("M-i"), lazy.layout.grow()),
    Key(("M-m"), lazy.layout.shrink()),
    Key(("M-n"), lazy.layout.reset()),
    Key(("M-o"), lazy.layout.maximize()),
    Key(("M-S-n"), lazy.layout.normalize()),
    Key(("M-S-<space>"), lazy.layout.flip()),
    Key(("M-S-h"), lazy.layout.swap_left()),
    Key(("M-S-l"), lazy.layout.swap_right()),
    Key(("M-S-j"), lazy.layout.shuffle_down()),
    Key(("M-S-k"), lazy.layout.shuffle_up()),
    Key(("M-C-h"), lazy.layout.grow_left()),
    Key(("M-C-l"), lazy.layout.grow_right()),
    Key(("M-C-j"), lazy.layout.grow_down()),
    Key(("M-C-k"), lazy.layout.grow_up()),
    Key(("M-n"), lazy.layout.normalize()),
    Key(("M-S-<Return>"), lazy.layout.toggle_split()),
    Key(("M-<Return>"), lazy.spawn(TERMINAL)),
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
    ], name="M-p"),
]

groups = [
    Group(f"{i}", label=label, layout=layout)
    for i, (label, layout) in enumerate([
        (S["1"], "monadtall"),
        (S["2"], "monadthreecol"),
        (S["3"], "monadwide"),
        (S["4"], "plasma"),
        (S["5"], "max"),
    ], 1)
]

for g in groups:
    keys.extend( [
        Key(f"M-{g.name}", lazy.group[g.name].toscreen()),
        Key(f"M-S-{g.name}", lazy.window.togroup(g.name, switch_group=True)),
    ])

groups.append( ScratchPad( "scratchpad", [
    DropDown("term", "kitty", width=0.4, x=0.3, y=0.2),
]))

mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]

layout_theme = {
    "border_width": 0,
    "margin": 8,
    "border_normal": C("background"),
    "border_focus": C("bright yellow"),
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadThreeCol(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Plasma(**layout_theme),
    Center(**layout_theme),
    layout.Max(**layout_theme),
]

widget_defaults = dict(font="SauceCodePro NF", fontsize=12, padding=0)
extension_defaults = widget_defaults.copy()

extra_widgets = [
    widget.Image(
        filename="~/pictures/logos/logo_custom.png",
        scale="False",
        background="#00000000",
        margin=4,
    ),
    Deco(C("selection_background"), "#00000000"),
    widget.TextBox(
        text="ayudaenpython.com",
        foreground=C("foreground"),
        background=C("selection_background"),
    ),
    Deco(C("selection_background"), "#00000000", side="R"),
]

squared_widgets = [
    widget.Wallpaper(directory=DIR, label="\u2318", **SW("magenta")),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[ICONS], scale=0.5, **SW("yellow", 50),
    ),
    widget.CurrentLayout(**SW("yellow")),
    widget.KeyboardLayout(configured_keyboards=["us", "es"], **SW("green")),
    widget.Clock(format="%d/%m/%Y %a \u231b %H:%M %p", **SW("blue")),
    widget.QuickExit(default_text="\u23fb ", **SW("red")),
]

angled_widgets = [
    Deco(C("background"), "#00000000"),
    widget.Wallpaper(directory=DIR, label="\u2318", **AW("magenta", True)),
    Deco(C("selection_background"), C("background")),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[ICONS], scale=0.5, **AW("yellow", False, 4),
    ),
    widget.CurrentLayout(**AW("yellow", False)),
    Deco(C("background"), C("selection_background")),
    widget.KeyboardLayout(configured_keyboards=["us", "es"], **AW("green", True)),
    Deco(C("selection_background"), C("background")),
    widget.Clock(format="%d/%m/%Y %a \u231b %H:%M %p", **AW("blue", False)),
    Deco(C("background"), C("selection_background")),
    widget.QuickExit(default_text="\u23fb ", **AW("red", True)),
    Deco(C("background"), "#00000000", side="R"),
]

widgets = [
    Deco(C("bright blue"), "#00000000"),
    Deco(C("bright red"), C("bright blue")),
    Deco(C("bright yellow"), C("bright red")),
    Deco(C("background"), C("bright yellow")),
    widget.GroupBox(
        background=C("background"),
        highlight_color=["000000", "282828"],
        highlight_method="line",
        active=C("foreground"),
        this_current_screen_border=C("bright yellow"),
    ),
    Deco(C("background"), "#00000000", side="R"),
    widget.Prompt(
        prompt="> ",
        foreground=C("selection_foreground"),
        background="#00000000",
        padding=4,
    ),
    widget.WindowName(
        foreground=C("foreground"),
        background="#00000000",
        format='{name}',
        padding=4,
    ),
    widget.Chord(
        chords_colors={"launch": ("#2980b9", "#00000000")},
        name_transform=lambda name: name.upper(),
        padding=8,
    ),
    widget.Systray(),
]

if EXTRAS:
    widgets[:0] = extra_widgets
if SQUARE:
    widgets += squared_widgets
else:
    widgets += angled_widgets

screens = [
    Screen(
        # wallpaper=set_wallpaper(), wallpaper_mode="fill",
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
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
