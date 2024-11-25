from libqtile.config import Click, Drag, Group, Key
from libqtile.lazy import lazy

from consts import ONE, TWO, THREE, FOUR, FIVE, SIX

MOD, ALT, ATLGR = "mod4", "mod1", "mod5"
TERMINAL = "kitty"

keys = [
    Key([MOD, ALT], "h", lazy.layout.left()),
    Key([MOD, ALT], "l", lazy.layout.right()),
    Key([MOD, ALT], "j", lazy.layout.down()),
    Key([MOD, ALT], "k", lazy.layout.up()),
    Key([MOD], "space", lazy.widget["keyboardlayout"].next_keyboard()),
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left()),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right()),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down()),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up()),
    Key([MOD, "control"], "h", lazy.layout.grow_left()),
    Key([MOD, "control"], "l", lazy.layout.grow_right()),
    Key([MOD, "control"], "j", lazy.layout.grow_down()),
    Key([MOD, "control"], "k", lazy.layout.grow_up()),
    Key([MOD], "n", lazy.layout.normalize()),
    Key([MOD, "shift"], "Return", lazy.layout.toggle_split()),
    Key([MOD], "Return", lazy.spawn(TERMINAL)),
    Key([MOD], "Tab", lazy.next_layout()),
    Key([MOD], "w", lazy.window.kill()),
    Key([MOD], "f", lazy.window.toggle_fullscreen()),
    Key([MOD], "t", lazy.window.toggle_floating()),
    Key([MOD, "control"], "r", lazy.reload_config()),
    Key([MOD, "control"], "q", lazy.shutdown()),
    Key([MOD], "r", lazy.spawncmd()),
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
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]
