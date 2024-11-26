import os
import subprocess
from random import choice

from libqtile import bar, layout, hook, widget
from libqtile.config import EzClick as Click, EzDrag as Drag, EzKey as Key
from libqtile.config import Group, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from consts import ONE, TWO, THREE, FOUR, FIVE, SIX
from consts import TRANSPARENT, KHAKI1, GREY3
from consts import PLE_LOWER_RIGHT_TRIANGLE, PLE_UPPER_LEFT_TRIANGLE
from consts import GREY3, GREY7, BLACK, TRANSPARENT, YELLOW, KHAKI1, TRUE_TRANSPARENT
from consts import CUSTOM_TEXT, ICONS_PATH, LOGO, FORMAT, KBS, CHORDS_COLOR

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


def fgbg(fg, bg):
    return {"foreground": fg, "background": bg}


def decoration(fg, bg, icon="left", size=24):
    T = {"left": PLE_LOWER_RIGHT_TRIANGLE, "right": PLE_UPPER_LEFT_TRIANGLE}
    return widget.TextBox(text=T[icon], fontsize=size, **fgbg(fg, bg))


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
    Key(("M-t"), lazy.window.toggle_floating()),
    Key(("M-C-r"), lazy.reload_config()),
    Key(("M-C-q"), lazy.shutdown()),
    Key(("M-r"), lazy.spawncmd()),
    Key(("M-C-m"), minimize()),
]

groups = [
    Group(f"{i}", label=label, layout=layout)
    for i, (label, layout) in enumerate([
        (ONE, 'bsp'),
        (TWO, 'monadtall'),
        (THREE, 'monadthreecol'),
        (FOUR, 'ratiotile'),
        (FIVE, 'floating'),
        (SIX, 'max'),
    ], 1)
]

for group in groups:
    keys.extend([
        Key(
            f"M-{group.name}",
            lazy.group[group.name].toscreen(),
            desc=f"Switch to group {group.name}",
        ),
        Key(
            f"M-S-{group.name}",
            lazy.window.togroup(group.name, switch_group=True),
            desc=f"Switch to & move focused W to group {group.name}",
        ),
    ])

mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]

layout_theme = {
    "border_width": 2, "margin": 4,
    "border_normal": GREY3, "border_focus": KHAKI1,
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadThreeCol(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Plasma(**layout_theme),
    layout.Max(**layout_theme),
]

widget_defaults = dict(
    font="SauceCodePro NF", fontsize=12, padding=0, background=GREY3,
)
extension_defaults = widget_defaults.copy()

widgets = [
    widget.Image(
        filename=LOGO, scale="False", background=TRUE_TRANSPARENT, margin=4,
    ),
    decoration(fg=BLACK, bg=TRUE_TRANSPARENT),
    widget.TextBox(text=CUSTOM_TEXT, **fgbg(YELLOW, BLACK)),
    decoration(fg=GREY3, bg=BLACK),
    widget.GroupBox(
        highlight_color=[GREY7, GREY7], highlight_method="line",
        active=KHAKI1, this_current_screen_border=YELLOW, padding=2,
    ),
    decoration(fg=GREY3, bg=TRANSPARENT, icon="right"),
    widget.Prompt(prompt="> ", **fgbg(KHAKI1, TRANSPARENT)),
    widget.WindowName(**fgbg(KHAKI1, TRANSPARENT), format='{name}'),
    widget.Chord(
        chords_colors=CHORDS_COLOR,
        name_transform=lambda name: name.upper(),
    ),
    widget.Systray(),
    decoration(fg=BLACK, bg=TRANSPARENT),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[os.path.expanduser(ICONS_PATH)],
        padding=2, scale=0.5, **fgbg(YELLOW, BLACK),
    ),
    widget.CurrentLayout(**fgbg(YELLOW, BLACK)),
    decoration(fg=GREY3, bg=BLACK),
    widget.KeyboardLayout(**fgbg(YELLOW, GREY3), configured_keyboards=KBS),
    decoration(fg=BLACK, bg=GREY3),
    widget.Clock(format=FORMAT, **fgbg(YELLOW, BLACK)),
    decoration(fg=GREY3, bg=BLACK),
    widget.QuickExit(default_text="exit", **fgbg(YELLOW, GREY3)),
    decoration(fg=GREY3, bg=TRUE_TRANSPARENT, icon="right"),
]

screens = [
    Screen(
        wallpaper=set_wallpaper(),
        wallpaper_mode="fill",
        top=bar.Bar(
            widgets,
            background=TRANSPARENT,
            size=24,
            opacity=0.85,
            margin=[4, 4, 2, 4],  # [N, E, S, W]
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

