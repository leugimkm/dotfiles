from libqtile import widget

from settings import defaults, style
from utils import wconf, deco

widget_defaults = dict(font="SauceCodePro NF", fontsize=12, padding=0)
extension_defaults = widget_defaults.copy()

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
