from libqtile import widget

from utils import AW, SW, C, Deco, style

widget_defaults = dict(font="SauceCodePro NF", fontsize=12, padding=0)
extension_defaults = widget_defaults.copy()

defaults = {
    "image": {
        "filename": "~/pictures/logos/logo_custom.png",
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
        "active": C("selection_foreground"),
        "inactive": C("selection_background"),
        "background": C("background"),
        "this_current_screen_border": C("bright yellow"),
    },
    "wallpaper": {
        "directory": "~/pictures/wallpapers/",
        "label": "\u2318",
    },
    "layout": {
        "mode": "both",
        "icon_first": False,
        "custom_icon_paths": ["~/pictures/icons/"],
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
    Deco(C("selection_background"), "#00000000"),
    widget.TextBox(**defaults["textbox"]),
    Deco(C("selection_background"), "#00000000", side="R"),
]

deco = [
    Deco(C("bright blue"), "#00000000"),
    Deco(C("bright red"), C("bright blue")),
    Deco(C("bright yellow"), C("bright red")),
]

base = [
    widget.Prompt(**defaults["prompt"]),
    widget.WindowName(**defaults["window"]),
    widget.Chord(padding=8),
    widget.Systray(),
]

minimal_circle = [
    Deco(C("background"), "#00000000", style="circle", side="R", fontsize=20),
    widget.GroupBox(block_highlight_text_color=C("yellow"), **defaults["groupbox"]),
    Deco(C("background"), "#00000000", style="circle", fontsize=20),
    *base,
]

minimal_angled = [
    Deco(C("background"), "#00000000"),
    widget.GroupBox(block_highlight_text_color=C("yellow"), **defaults["groupbox"]),
    Deco(C("background"), "#00000000", side="R"),
    *base,
]

default = [
    *deco,
    Deco(C("background"), C("bright yellow")),
    widget.GroupBox(**defaults["groupbox"]),
    Deco(C("background"), "#00000000", side="R"),
    *base,
]

r_squared = [
    widget.Wallpaper(**defaults["wallpaper"], **SW("magenta")),
    widget.CurrentLayout(**defaults["layout"], **SW("yellow", 50)),
    widget.KeyboardLayout(**defaults["keyboard"], **SW("green")),
    widget.Clock(**defaults["clock"], **SW("blue")),
    widget.QuickExit(**defaults["exit"], **SW("red")),
]

r_angled = [
    Deco(C("background"), "#00000000"),
    widget.Wallpaper(**defaults["wallpaper"], **AW("magenta", True)),
    Deco(C("selection_background"), C("background")),
    widget.CurrentLayout(**defaults["layout"], **AW("yellow", False, 4)),
    Deco(C("background"), C("selection_background")),
    widget.KeyboardLayout(**defaults["keyboard"], **AW("green", True)),
    Deco(C("selection_background"), C("background")),
    widget.Clock(**defaults["clock"], **AW("blue", False)),
    Deco(C("background"), C("selection_background")),
    widget.QuickExit(**defaults["exit"], **AW("red", True)),
    Deco(C("background"), "#00000000", side="R"),
]

minimal = minimal_circle if style["circle"] else minimal_angled
widgets = minimal if style["minimal"] else default

if style["extra"]:
    widgets[:0] = extra
if style["squared"]:
    widgets += r_squared
else:
    widgets += r_angled
