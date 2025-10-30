from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import EzClick as Click, EzDrag as Drag, EzKey as Key
from libqtile.config import Group, Match, Screen, EzKeyChord as KeyChord
from libqtile.config import ScratchPad, DropDown
from libqtile.lazy import lazy

from consts import SYMBOLS as S
from settings import MINIMAL, style, terminal
from utils import deco, wconf, Center, C


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

groups = [ Group(f"{i}", label=label, layout=layout) for i, (label, layout) in
    enumerate([
        [S[f"{i}"] if not MINIMAL else [S["inactive"]], layout]
        for i, layout in enumerate(
            ["columns", "monadtall", "monadwide", "max", "center"], 1
    )], 1)
]
for g in groups:
    keys.extend( [
        Key(f"M-{g.name}", lazy.group[g.name].toscreen()),
        Key(f"M-S-{g.name}", lazy.window.togroup(g.name, switch_group=True)),
    ])
groups.append(
    ScratchPad("scratchpad", [DropDown( "term", terminal, width=0.4, x=0.3, y=0.2)])
)

mouse = [
    Drag("M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
]

layout_defaults = {
    "border_width": 0, "margin": 8,
    "border_normal": C("background"),
    "border_focus": C("bright yellow"),
}
layouts = [
    layout.Columns(**layout_defaults),
    layout.MonadTall(**layout_defaults),
    layout.MonadWide(**layout_defaults),
    Center(**layout_defaults),
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

widget_defaults = dict(font="SauceCodePro NF", fontsize=12, padding=0)
extension_defaults = widget_defaults.copy()

defaults = {
    "image": {
        "filename": "~/Pictures/logos/logo_custom.png",
        "scale": False,
        "margin": 4,
        "background": "#00000000",
    },
    "textbox": {
        "text": "ayudaenpython.com",
        "foreground": C("foreground"),
        "background": C("selection_background"),
    },
    "prompt": {
        "prompt": "> ",
        "padding": 4,
        "foreground": C("selection_foreground"),
        "background": "#00000000",
    },
    "window": {
        "format": "{name}",
        "padding": 4,
        "foreground": C("foreground"),
        "background": "#00000000",
    },
    "groupbox": {
        "highlight_method": "line",
        "highlight_color": ["00000000", "00000000"],
        "block_highlight_text_color": C("yellow"),
        "active": C("selection_foreground"),
        "inactive": C("selection_background"),
        "background": C("background"),
        "this_current_screen_border": C("bright yellow"),
    },
    "wallpaper": {
        "directory": "~/Pictures/wallpapers/",
        "label": "\u2318",
    },
    "layout": {
        "mode": "both",
        "icon_first": False,
        "custom_icon_paths": ["~/Pictures/icons/"],
        "scale": 0.5,
    },
    "keyboard": {"configured_keyboards": ["us", "es"]},
    "clock": {"format": "%d/%m/%Y %a \u231b %H:%M %p"},
    "exit": {
        "default_text": "\u23fb ",
        "countdown_format": "[{}]",
    },
}

extra = [
    widget.Image(**defaults["image"]),
    deco("selection_background"),
    widget.TextBox(**defaults["textbox"]),
    deco("selection_background", side="R"),
]

base = [
    widget.Prompt(**defaults["prompt"]),
    widget.WindowName(**defaults["window"]),
    widget.Chord(padding=8),
    widget.Systray(),
]

minimal_circle = [
    deco("background", style="circle", side="R", fontsize=20),
    widget.GroupBox(**defaults["groupbox"]),
    deco("background", style="circle", fontsize=20),
]

minimal_angled = [
    deco("background"),
    widget.GroupBox(**defaults["groupbox"]),
    deco("background", side="R"),
]

default = [
    deco("bright blue"),
    deco("bright red", "bright blue"),
    deco("bright yellow", "bright red"),
    deco("background", "bright yellow"),
    widget.GroupBox(**defaults["groupbox"]),
    deco("background", side="R"),
]

r_squared = [
    widget.Wallpaper(**defaults["wallpaper"], **wconf("magenta", style="S")),
    widget.CurrentLayout(**defaults["layout"], **wconf("yellow", style="S")),
    widget.KeyboardLayout(**defaults["keyboard"], **wconf("green", style="S")),
    widget.Clock(**defaults["clock"], **wconf("blue", style="S")),
    widget.QuickExit(**defaults["exit"], **wconf("red", style="S")),
]

r_angled = [
    deco("background"),
    widget.Wallpaper(**defaults["wallpaper"], **wconf("magenta")),
    deco("selection_background", "background"),
    widget.CurrentLayout(**defaults["layout"], **wconf("yellow", bg=False, pad=4)),
    deco("background", "selection_background"),
    widget.KeyboardLayout(**defaults["keyboard"], **wconf("green")),
    deco("selection_background", "background"),
    widget.Clock(**defaults["clock"], **wconf("blue", bg=False)),
    deco("background", "selection_background"),
    widget.QuickExit(**defaults["exit"], **wconf("red")),
    deco("background", side="R"),
]

minimal = minimal_circle if style["circle"] else minimal_angled
widgets = minimal if style["minimal"] else default
widgets += base
if style["extra"]:
    widgets[:0] = extra
if style["squared"]:
    widgets += r_squared
else:
    widgets += r_angled

screens = [
    Screen(
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
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
