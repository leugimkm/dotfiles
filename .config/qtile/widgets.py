from os import path

from libqtile import widget

from colors import *
from icons import *

LOGO = "~/pictures/logos/aep_logo.png"
CUSTOM_TEXT = "ayudaenpython.com"
ICONS_PATH = "~/pictures/icons"

widget_defaults = dict(
    font="SauceCodePro NF",
    fontsize=12,
    padding=0,
    background=GREY3,
)
extension_defaults = widget_defaults.copy()

widgets = [
    widget.Image(
        background=TRANSPARENT,
        filename=LOGO,
        scale="False",
    ),
    widget.TextBox(
        text=PLE_LOWER_RIGHT_TRIANGLE,
        foreground=TRUE_BLACK,
        background=TRANSPARENT,
        fontsize=24,
    ),
    widget.TextBox(
        text=CUSTOM_TEXT,
        foreground=KHAKI1,
        background=TRUE_BLACK,
    ),
    widget.TextBox(
        text=PLE_LOWER_RIGHT_TRIANGLE,
        foreground=GREY3,
        background=TRUE_BLACK,
        fontsize=24,
    ),
    widget.GroupBox(
        highlight_color=[GREY7, GREY7],
        highlight_method="line",
        active=[YELLOW, YELLOW],
        this_current_screen_border=[YELLOW, YELLOW],
    ),
    widget.TextBox(
        text=PLE_UPPER_LEFT_TRIANGLE,
        foreground=GREY3,
        background=TRANSPARENT,
        fontsize=24,
    ),
    widget.Prompt(
        prompt="> ",
        foreground=KHAKI1,
        background=TRANSPARENT,
    ),
    widget.WindowName(
        format='{name}',
        foreground=KHAKI1,
        background=TRANSPARENT,
    ),
    widget.Chord(
        chords_colors={
            "launch": ("#ff0000", "#ffffff"),
        },
        name_transform=lambda name: name.upper(),
    ),
    widget.Systray(),
    widget.TextBox(
        text=PLE_LOWER_RIGHT_TRIANGLE,
        foreground=TRUE_BLACK,
        background=TRANSPARENT,
        fontsize=24,
    ),
    widget.CurrentLayoutIcon(
        custom_icon_paths=[path.expanduser(ICONS_PATH)],
        foreground=YELLOW,
        background=TRUE_BLACK,
        padding=2,
        scale=0.5,
    ),
    widget.CurrentLayout(
        foreground=YELLOW,
        background=TRUE_BLACK,
    ),
    widget.TextBox(
        text=PLE_LOWER_RIGHT_TRIANGLE,
        foreground=YELLOW,
        background=TRUE_BLACK,
        fontsize=24,
    ),
    widget.KeyboardLayout(
        foreground=TRUE_BLACK,
        background=YELLOW,
        configured_keyboards=['us', 'es'],
    ),
    widget.TextBox(
        text=PLE_LOWER_RIGHT_TRIANGLE,
        foreground=GREY3,
        background=YELLOW,
        fontsize=24,
    ),
    widget.Clock(
        foreground=YELLOW,
        background=GREY3,
        format="%d/%m/%Y %a %I:%M %p",
    ),
    widget.TextBox(
        text=PLE_LOWER_RIGHT_TRIANGLE,
        foreground=TRUE_BLACK,
        background=GREY3,
        fontsize=24,
    ),
    widget.QuickExit(
        foreground=YELLOW,
        background=TRUE_BLACK,
        default_text="exit",
    ),
    widget.TextBox(
        text=PLE_UPPER_LEFT_TRIANGLE,
        fontsize=24,
        foreground=TRUE_BLACK,
        background=TRANSPARENT,
    ),
]