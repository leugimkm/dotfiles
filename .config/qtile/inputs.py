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
    Key([MOD, ALT], "h", lazy.layout.left(), desc="Move focus to L"),
    Key([MOD, ALT], "l", lazy.layout.right(), desc="Move focus to R"),
    Key([MOD, ALT], "j", lazy.layout.down(), desc="Move focus D"),
    Key([MOD, ALT], "k", lazy.layout.up(), desc="Move focus U"),
    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left(), desc="Move W to the L"),
    Key([MOD, SHIFT], "l", lazy.layout.shuffle_right(), desc="Move W to the R"),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down(), desc="Move W D"),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up(), desc="Move W U"),
    Key([MOD, CTRL], "h", lazy.layout.grow_left(), desc="Grow W to the L"),
    Key([MOD, CTRL], "l", lazy.layout.grow_right(), desc="Grow W to the R"),
    Key([MOD, CTRL], "j", lazy.layout.grow_down(), desc="Grow W D"),
    Key([MOD, CTRL], "k", lazy.layout.grow_up(), desc="Grow W U"),
    Key([MOD], "n", lazy.layout.normalize(), desc="Reset all W sizes"),
    Key([MOD], TAB, lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD, CTRL], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, CTRL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([MOD], "r", lazy.spawncmd(), desc="Spawn a CMD using a prompt widget"),
    Key([MOD], "w", lazy.window.kill(), desc="Kill focused W"),
    Key([MOD], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([MOD, SHIFT], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split/unsplit sides of stack"),
    Key([MOD], "f", lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused W"),
    Key([MOD], "t", lazy.window.toggle_floating(),
        desc="Toggle floating on the focused W"),
    Key([MOD], "space", lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout"),
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
