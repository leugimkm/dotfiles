import os
from random import choice

from libqtile import bar
from libqtile.config import Screen

from widgets import widgets
from consts import TRANSPARENT


def set_wallpaper():
    dir_ = os.path.expanduser('~/pictures/wallpapers')
    return os.path.join(dir_, choice(os.listdir(dir_)))


screens = [
    Screen(
        wallpaper=set_wallpaper(),
        wallpaper_mode="fill",
        top=bar.Bar(
            widgets,
            background=TRANSPARENT,
            size=24,
            opacity=0.85,
            margin=[4, 4, 2, 4],  # [N, E, S, W]
        ),
    ),
]
