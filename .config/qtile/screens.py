from libqtile import bar
from libqtile.config import Screen

from widgets import widgets
from colors import TRANSPARENT

WALLPAPER = "~/pictures/wallpapers/00.jpg"

screens = [
    Screen(
        top=bar.Bar(
            widgets,
            size=24,
            background=TRANSPARENT,
            opacity=1,
            margin=[10, 10, 4, 10],  # [N, E, S, W]
        ),
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
    ),
]
