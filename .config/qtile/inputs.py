from libqtile.config import Click, Drag, Group, Key
from libqtile.lazy import lazy

from consts import ONE, TWO, THRE, FOUR, FIVE, SIX

MOD = "mod4"
ALT = "mod1"
ALTGR = "mod5"
SHIFT = "shift"
CTRL = "control"
TAB = "Tab"
terminal = "kitty"

keys = [
    Key([MOD, ALT], "h", lazy.layout.left()),
    Key([MOD, ALT], "l", lazy.layout.right()),
    Key([MOD, ALT], "j", lazy.layout.down()),
    Key([MOD, ALT], "k", lazy.layout.up()),
    Key([MOD], "space", lazy.widget["keyboardlayout"].next_keyboard()),
    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left()),
    Key([MOD, SHIFT], "l", lazy.layout.shuffle_right()),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down()),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up()),
    Key([MOD, CTRL], "h", lazy.layout.grow_left()),
    Key([MOD, CTRL], "l", lazy.layout.grow_right()),
    Key([MOD, CTRL], "j", lazy.layout.grow_down()),
    Key([MOD, CTRL], "k", lazy.layout.grow_up()),
    Key([MOD], "n", lazy.layout.normalize()),
    Key([MOD, SHIFT], "Return", lazy.layout.toggle_split()),
    Key([MOD], "Return", lazy.spawn(terminal)),
    Key([MOD], TAB, lazy.next_layout()),
    Key([MOD], "w", lazy.window.kill()),
    Key([MOD], "f", lazy.window.toggle_fullscreen()),
    Key([MOD], "t", lazy.window.toggle_floating()),
    Key([MOD, CTRL], "r", lazy.reload_config()),
    Key([MOD, CTRL], "q", lazy.shutdown()),
    Key([MOD], "r", lazy.spawncmd()),
]

groups = [
    Group(f"{i}", label=label, layout=layout)
    for i, (label, layout)
    in enumerate([
        (ONE, 'bsp'),
        (TWO, 'monadtall'),
        (THRE, 'monadthreecol'),
        (FOUR, 'ratiotile'),
        (FIVE, 'floating'),
        (SIX, 'max'),
    ], 1)
]

for group in groups:
    keys.extend([
        Key(
            [MOD], group.name,
            lazy.group[group.name].toscreen(),
            desc="Switch to group {}".format(group.name),
        ),
        Key(
            [MOD, "shift"], group.name,
            lazy.window.togroup(group.name, switch_group=True),
            desc="Switch to & move focused W to group {}".format(group.name),
        ),
    ])

mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([MOD], "Button1", lazy.window.bring_to_front()),
]
