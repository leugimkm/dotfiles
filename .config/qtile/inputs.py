from libqtile.config import Click, Drag, Group, Key
from libqtile.lazy import lazy

mod = "mod4"
terminal = "kitty"

keys = [
    Key([mod], "h", lazy.layout.left(),
        desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(),
        desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(),
        desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(),
    #    desc="Move window focus to other window"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the righ"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(),
        desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all W sizes"),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split/unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal),
        desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(),
        desc="Kill focused W"),
    Key([mod], "f", lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused W"),
    Key([mod], "t", lazy.window.toggle_floating(),
        desc="Toggle floating on the focused W"),
    Key([mod, "control"], "r", lazy.reload_config(),
        desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(),
        desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout"),
]

groups = [
    Group(f"{i}", label=label, layout=layout)
    for i, (label, layout)
    in enumerate([
        ('\U000f0f0f', 'bsp'),
        ('\U000f0f10', 'monadtall'),
        ('\U000f0f11', 'monadthreecol'),
        ('\U000f0f12', 'ratiotile'),
        ('\U000f0f13', 'floating'),
        ('\U000f0f14', 'max'),
    ], 1)
]

for group in groups:
    keys.extend([
        Key(
            [mod], group.name,
            lazy.group[group.name].toscreen(),
            desc="Switch to group {}".format(group.name),
        ),
        Key(
            [mod, "shift"], group.name,
            lazy.window.togroup(group.name, switch_group=True),
            desc="Switch to & move focused W to group {}".format(group.name),
        ),
    ])

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button1", lazy.window.bring_to_front()),
]
