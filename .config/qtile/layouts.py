from libqtile import layout
from libqtile.config import Match

from consts import KHAKI1, GREY3

layout_theme = {
    "border_width": 2,
    "margin": 4,
    "border_focus": KHAKI1,
    "border_normal": GREY3,
}

layouts = [
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    layout.MonadThreeCol(**layout_theme),
]

floating_layout = layout.Floating(
    border_width=2,
    border_focus=KHAKI1,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)

