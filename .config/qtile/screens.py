from libqtile import bar
from libqtile.config import Screen

from widgets import widgets
from consts import TRANSPARENT

WALLPAPER = "~/pictures/wallpapers/01.jpg"

screens = [
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
        top=bar.Bar(
            widgets,
            background=TRANSPARENT,
            size=24,
            opacity=1,
            margin=[10, 10, 4, 10],  # [N, E, S, W]
        ),
    ),
]
