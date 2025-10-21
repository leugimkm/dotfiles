from pathlib import Path

from libqtile import bar
from libqtile.command.base import expose_command
from libqtile.layout.base import _SimpleLayoutBase
from libqtile.widget.base import _TextBox
from libqtile.utils import guess_terminal

from consts import ALIASES, PLE, THEME

HOME = Path.home()
WALLPAPERS = HOME.joinpath("pictures", "wallpapers")
ICONS = HOME.joinpath("pictures", "icons")
LOGO = HOME.joinpath("pictures", "logos", "logo_custom.png")
COLORSCHEME = "gruvbox"
MINIMAL = True
style = {
    "extra": False,
    "minimal": True,
    "circle": False,
    "squared": False,
}
terminal = guess_terminal()


class ColorTheme:
    def __init__(self, theme):
        self.theme = theme

    def _alpha_to_hex(self, alpha):
        if not (0 <= alpha <= 100):
            return "ff"
        return f"{round(alpha * 255 / 100):02X}"

    def _resolve_key(self, value):
        value_ = value.strip().lower()
        if value_.isdigit():
            return f"color{value_}"
        if value_.startswith("color") and value_[5:].isdigit():
            return value_
        if value_ in ALIASES:
            return ALIASES[value_]
        return "background"

    def __call__(self, value, alpha=100):
        key_ = self._resolve_key(value)
        base_color = self.theme[key_]
        if base_color.startswith("#"):
            base_color = base_color[1:]
        alpha_hex = self._alpha_to_hex(alpha)
        return f"#{base_color}{alpha_hex}"


class Deco(_TextBox):
    defaults = [
        ("fontsize", None, "Font pixel size. Calculated if None."),
        ("fontshadow", None, "font shadow color, default is None (no shadow)."),
        ("padding", None, "Padding left and right. Calculated if None."),
        ("foreground", "#ffffff", "Foreground color."),
    ]

    def __init__(
        self,
        foreground,
        background,
        style="triangle",
        side="L",
        width=bar.CALCULATED,
        fontsize=24,
        **config,
    ):
        _t = {}
        if style == "triangle":
            T = PLE["triangle"]
            _t = {"L": T["lower"]["R"], "R": T["upper"]["L"]}
        elif style == "circle":
            T = PLE["half_circle"]
            _t = {"L": T["R"], "R": T["L"]}
        elif style == "divider":
            T = PLE["hard_divider_inverse"]
            _t = {"L": T["R"], "R": T["L"]}
        super().__init__(
            text=f"{_t[side]}",
            foreground=foreground,
            background=background,
            width=width,
            fontsize=fontsize,
            **config,
        )

    @expose_command
    def get(self):
        return self.text

    @expose_command
    def update(self, text):
        super().update(self, text)


class Center(_SimpleLayoutBase):
    defaults = [
        ("margin", 0, "Margin of the layout (int or list of ints [N E S W])"),
        ("border_focus", "#0000ff", "Border color(s) for the W when F"),
        ("border_normal", "#000000", "Border color(s) for the W when not F"),
        ("border_width", 0, "Border width."),
        ("sizing_mode", "absolute", "Size of the W rect: abs or rel."),
        ("width", 1280, "The W rect's width."),
        ("height", 720, "The W rect's height."),
        ("grow_amount", 100, "Amount by which to grow/shrink the W."),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(Center.defaults)

    def add_client(self, client):
        return super().add_client(client, 1)

    def configure(self, client, screen_rect):
        if self.clients and client is self.clients.current_client:
            w = (
                screen_rect.width * self.width
                if self.sizing_mode == "relative"
                else self.width
            ) - self.border_width * 2
            h = (
                screen_rect.height * self.height
                if self.sizing_mode == "relative"
                else self.height
            ) - self.border_width * 2

            client.place(
                screen_rect.x + int((screen_rect.width - w) / 2),
                screen_rect.y + int((screen_rect.height - h) / 2),
                w,
                h,
                self.border_width,
                self.border_focus if client.has_focus else self.border_normal,
                margin=self.margin,
            )
            client.unhide()
        else:
            client.hide()

    @expose_command("previous")
    def up(self):
        super().previous()

    @expose_command("next")
    def down(self):
        super().next()

    @expose_command
    def resize(self, resize_by=(0, 0)):
        self.width = self.width + resize_by[0]
        self.height = self.height + resize_by[1]
        self.group.layout_all()

    @expose_command(["grow_left", "grow_right"])
    def grow_h(self):
        self.resize((self.grow_amount, 0))

    @expose_command(["grow_up", "grow_down"])
    def grow_v(self):
        self.resize((0, self.grow_amount))

    @expose_command(["shrink_left", "shrink_right"])
    def shrink_h(self):
        self.resize((-self.grow_amount, 0))

    @expose_command(["shrink_up", "shrink_down"])
    def shrink_v(self):
        self.resize((0, -self.grow_amount))


C = ColorTheme(THEME[COLORSCHEME])


def AW(color, bg=True, pad=0):
    bg_color = "background" if bg else "selection_background"
    return {
        "foreground": C(f"bright {color}"),
        "background": C(bg_color),
        "padding": pad,
    }


def SW(color, shade=35, pad=8):
    return {
        "foreground": C(f"bright {color}"),
        "background": C(color, shade),
        "padding": pad,
    }
