from pathlib import Path

from libqtile.utils import guess_terminal

HOME = Path.home() / "Pictures"
WALLPAPERS = HOME / "wallpapers"
ICONS = HOME / "icons"
LOGO = HOME / "logos" / "logo_custom.png"
MINIMAL = True
COLORSCHEME = "gruvbox"
terminal = guess_terminal()

style = {
    "extra": False,
    "minimal": True,
    "circle": False,
    "squared": False,
}

