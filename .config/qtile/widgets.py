import os

from libqtile import widget

from consts import PLE_LOWER_RIGHT_TRIANGLE, PLE_UPPER_LEFT_TRIANGLE
from consts import GREY3, GREY7, TRUE_BLACK, TRANSPARENT, YELLOW, KHAKI1


def fgbg(fg, bg):
    return {"foreground": fg, "background": bg}


def decoration(fg, bg, icon="left", size=24):
    T = {"left": PLE_LOWER_RIGHT_TRIANGLE, "right": PLE_UPPER_LEFT_TRIANGLE}
    return widget.TextBox(text=T[icon], fontsize=size, **fgbg(fg, bg))


CUSTOM_TEXT = "ayudaenpython.com"
ICONS_PATH = "~/pictures/icons"
LOGO = "~/pictures/logos/aep_logo.png"
FORMAT = "%d/%m/%Y %a %I:%M %p"
KBS = ["us", "es"]

widget_defaults = dict(
    font="SauceCodePro NF",
    background=GREY3,
    fontsize=12,
    padding=0,
)
extension_defaults = widget_defaults.copy()

widgets = [
    widget.Image(filename=LOGO, scale="False", background=TRANSPARENT),
    decoration(fg=TRUE_BLACK, bg=TRANSPARENT),
    widget.TextBox(text=CUSTOM_TEXT, **fgbg(YELLOW, TRUE_BLACK)),
    decoration(fg=GREY3, bg=TRUE_BLACK),
    widget.GroupBox(
        highlight_color=[GREY7, GREY7], highlight_method="line",
        active=KHAKI1, this_current_screen_border=YELLOW, padding=2,
    ),
    decoration(fg=GREY3, bg=TRANSPARENT, icon="right"),
    widget.Prompt(prompt="> ", **fgbg(KHAKI1, TRANSPARENT)),
    widget.WindowName(**fgbg(KHAKI1, TRANSPARENT), format='{name}'),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
            "vim mode": ("#2980b9", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Systray(),
    decoration(fg=TRUE_BLACK, bg=TRANSPARENT),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[os.path.expanduser(ICONS_PATH)],
        padding=2, scale=0.5, **fgbg(YELLOW, TRUE_BLACK),
    ),
    widget.CurrentLayout(**fgbg(YELLOW, TRUE_BLACK)),
    decoration(fg=GREY3, bg=TRUE_BLACK),
    widget.KeyboardLayout(**fgbg(YELLOW, GREY3), configured_keyboards=KBS),
    decoration(fg=TRUE_BLACK, bg=GREY3),
    widget.Clock(format=FORMAT, **fgbg(YELLOW, TRUE_BLACK)),
    decoration(fg=GREY3, bg=TRUE_BLACK),
    widget.QuickExit(default_text="exit", **fgbg(YELLOW, GREY3)),
    decoration(fg=GREY3, bg=TRANSPARENT, icon="right"),
]
