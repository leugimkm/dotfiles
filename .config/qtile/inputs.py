from libqtile.config import EzClick as Click, EzDrag as Drag, EzKey as Key
from libqtile.config import Group
from libqtile.lazy import lazy

from consts import ONE, TWO, THREE, FOUR, FIVE, SIX

TERMINAL = "kitty"

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
    Key(("M-<Return>"), lazy.spawn(TERMINAL)),
    Key(("M-<Tab>"), lazy.next_layout()),
    Key(("M-w"), lazy.window.kill()),
    Key(("M-f"), lazy.window.toggle_fullscreen()),
    Key(("M-t"), lazy.window.toggle_floating()),
    Key(("M-C-r"), lazy.reload_config()),
    Key(("M-C-q"), lazy.shutdown()),
    Key(("M-r"), lazy.spawncmd()),
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
            desc="Switch to group {}".format(group.name),
        ),
        Key(
            f"M-S-{group.name}",
            lazy.window.togroup(group.name, switch_group=True),
            desc="Switch to & move focused W to group {}".format(group.name),
        ),
    ])

mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]
