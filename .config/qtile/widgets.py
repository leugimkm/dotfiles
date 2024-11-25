import os

from libqtile import widget

from consts import PLE_LOWER_RIGHT_TRIANGLE, PLE_UPPER_LEFT_TRIANGLE
from consts import GREY3, GREY7, BLACK, TRANSPARENT, YELLOW, KHAKI1


def fgbg(fg, bg):
    return {"foreground": fg, "background": bg}


def decoration(fg, bg, icon="left", size=24):
    T = {"left": PLE_LOWER_RIGHT_TRIANGLE, "right": PLE_UPPER_LEFT_TRIANGLE}
    return widget.TextBox(text=T[icon], fontsize=size, **fgbg(fg, bg))


CUSTOM_TEXT = "ayudaenpython.com"
ICONS_PATH = "~/pictures/icons"
LOGO = "~/pictures/logos/logo_custom.png"
FORMAT = "%d/%m/%Y %a %I:%M %p"
KBS = ["us", "es"]
CHORDS_COLOR = {
    "launch": ("#ff0000", "#ffffff"),
    "vim mode": ("#2980b9", "#ffffff"),
}

widget_defaults = dict(
    font="SauceCodePro NF", fontsize=12, padding=0, background=GREY3,
)
extension_defaults = widget_defaults.copy()

widgets = [
    widget.Image(
        filename=LOGO, scale="False", background=TRANSPARENT, margin=4,
    ),
    decoration(fg=BLACK, bg=TRANSPARENT),
    widget.TextBox(text=CUSTOM_TEXT, **fgbg(YELLOW, BLACK)),
    decoration(fg=GREY3, bg=BLACK),
    widget.GroupBox(
        highlight_color=[GREY7, GREY7], highlight_method="line",
        active=KHAKI1, this_current_screen_border=YELLOW, padding=2,
    ),
    decoration(fg=GREY3, bg=TRANSPARENT, icon="right"),
    widget.Prompt(prompt="> ", **fgbg(KHAKI1, TRANSPARENT)),
    widget.WindowName(**fgbg(KHAKI1, TRANSPARENT), format='{name}'),
    widget.Chord(
        chords_colors=CHORDS_COLOR,
        name_transform=lambda name: name.upper(),
    ),
    widget.Systray(),
    decoration(fg=BLACK, bg=TRANSPARENT),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[os.path.expanduser(ICONS_PATH)],
        padding=2, scale=0.5, **fgbg(YELLOW, BLACK),
    ),
    widget.CurrentLayout(**fgbg(YELLOW, BLACK)),
    decoration(fg=GREY3, bg=BLACK),
    widget.KeyboardLayout(**fgbg(YELLOW, GREY3), configured_keyboards=KBS),
    decoration(fg=BLACK, bg=GREY3),
    widget.Clock(format=FORMAT, **fgbg(YELLOW, BLACK)),
    decoration(fg=GREY3, bg=BLACK),
    widget.QuickExit(default_text="exit", **fgbg(YELLOW, GREY3)),
    decoration(fg=GREY3, bg=TRANSPARENT, icon="right"),
]
