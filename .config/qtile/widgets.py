from libqtile import widget

from settings import style
from utils import C, deco, wconf

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
