from libqtile import layout, hook, qtile
from libqtile.config import Group, Match, ScratchPad, DropDown
from libqtile.config import (
    EzClick as Click, EzDrag as Drag, EzKey as Key, EzKeyChord as KeyChord
)
from libqtile.lazy import lazy

from consts import SYMBOLS as S
from settings import MINIMAL, terminal


@hook.subscribe.setgroup
def setgroup():
    if MINIMAL:
        for group in qtile.groups[:-1]:
            group.label = S["inactive"]
        qtile.current_group.label = S["active"]


keys = [Key(*args) for args in [
    ("C-S-h", lazy.layout.left()),
    ("C-S-l", lazy.layout.right()),
    ("C-S-j", lazy.layout.down()),
    ("C-S-k", lazy.layout.up()),
    ("M-S-h", lazy.layout.swap_left(), lazy.layout.shuffle_left().when(layout="columns")),
    ("M-S-l", lazy.layout.swap_right(), lazy.layout.shuffle_right().when(layout="columns")),
    ("M-S-j", lazy.layout.shuffle_down()),
    ("M-S-k", lazy.layout.shuffle_up()),
    ("M-i", lazy.layout.grow()),
    ("M-m", lazy.layout.shrink()),
    ("M-n", lazy.layout.reset()),
    ("M-o", lazy.layout.maximize()),
    ("M-S-n", lazy.layout.normalize()),
    ("M-S-<space>", lazy.layout.flip()),
    ("M-C-h", lazy.layout.grow_left().when(layout="columns")),
    ("M-C-l", lazy.layout.grow_right().when(layout="columns")),
    ("M-C-j", lazy.layout.grow_down().when(layout="columns")),
    ("M-C-k", lazy.layout.grow_up().when(layout="columns")),
    ("M-S-C-h", lazy.layout.swap_column_left().when(layout="columns")),
    ("M-S-C-l", lazy.layout.swap_column_right().when(layout="columns")),
    ("M-S-<Return>", lazy.layout.toggle_split()),
    ("M-j", lazy.group.next_window(), lazy.window.bring_to_front()),
    ("M-k", lazy.group.prev_window(), lazy.window.bring_to_front()),
    ("M-<space>", lazy.widget["keyboardlayout"].next_keyboard()),
    ("M-<Return>", lazy.spawn(terminal)),
    ("M-<Tab>", lazy.next_layout()),
    ("M-b", lazy.hide_show_bar()),
    ("M-w", lazy.window.kill()),
    ("M-f", lazy.window.toggle_fullscreen()),
    ("M-t", lazy.window.toggle_floating()),
    ("M-C-r", lazy.reload_config()),
    ("M-C-q", lazy.shutdown()),
    ("M-r", lazy.spawncmd()),
    ("M-C-m", lazy.function(
        lambda q: [w.toggle_minimize() for w in q.current_group.windows
        if hasattr(w, "toggle_minimize")])
     ),
]]
keys.append(
    KeyChord("M-p", [Key(*args) for args in [
        ("f", lazy.spawn("firefox")),
        ("q", lazy.spawn("qutebrowser")),
        ("r", lazy.spawn("rofi -show drun")),
        ("t", lazy.group["scratchpad"].dropdown_toggle("term")),
    ]], name="M-p")
)

mouse = [
    Drag("M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]

groups = [ Group(f"{i}", label=label, layout=layout) for i, (label, layout) in
    enumerate([
        [S[f"{i}"] if not MINIMAL else [S["inactive"]], layout]
        for i, layout in enumerate(
            ["columns", "monadtall", "monadwide", "max"], 1
    )], 1)
]
for g in groups:
    keys.extend([
        Key(f"M-{g.name}", lazy.group[g.name].toscreen()),
        Key(f"M-S-{g.name}", lazy.window.togroup(g.name, switch_group=True)),
    ])
groups.append(
    ScratchPad("scratchpad", [DropDown( "term", terminal, width=0.4, x=0.3, y=0.2)])
)

layout_defaults = {"border_width": 0, "margin": 8}
layouts = [
    layout.Columns(**layout_defaults),
    layout.MonadTall(**layout_defaults),
    layout.MonadWide(**layout_defaults),
    layout.Max(margin=[170, 328, 170, 328]),
]
floating_layout = layout.Floating(
    **layout_defaults,
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
