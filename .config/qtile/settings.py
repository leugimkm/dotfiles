from pathlib import Path

from libqtile.utils import guess_terminal

from utils import ColorTheme

HOME = Path.home() / "pictures"
WALLPAPERS = HOME / "wallpapers"
ICONS = HOME / "icons"
LOGO = HOME / "logos" / "logo_custom.png"
MINIMAL = True
terminal = guess_terminal()
C = ColorTheme("gruvbox")

style = {
    "extra": False,
    "minimal": True,
    "circle": False,
    "squared": False,
}

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
        "block_highlight_text_color": C("yellow"),
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
