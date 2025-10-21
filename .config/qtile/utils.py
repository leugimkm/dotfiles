from libqtile import bar, widget
from libqtile.command.base import expose_command
from libqtile.layout.base import _SimpleLayoutBase

from consts import ALIASES, PLE, THEME
from settings import C


def alpha_to_hex(alpha):
    if not (0 <= alpha <= 100):
        return "ff"
    return f"{round(alpha * 255 / 100):02X}"


def resolve(value, alpha=100):
    if not value or value == "transparent":
        return "#00000000"
    if isinstance(value, str) and value.startswith("#"):
        base = value[1:]
        return f"#{base}{alpha_to_hex(alpha)}"
    return C(value, alpha)


def wconf(color, *, style="A", bg=True, pad=-1, shade=35):
    """style(str): Can be "A"(Angled) or "S"(Squared)."""
    bg_ = None
    if style == "A":
        bg_ = resolve("background" if bg else "selection_background")
    elif style == "S":
        pad = 8
        bg_ = resolve(color, shade)
    return {
        "foreground": resolve(f"bright {color}"),
        "background": bg_,
        "padding": pad,
    }


class ColorTheme:
    def __init__(self, colorscheme):
        self.theme = THEME[colorscheme]

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
        base_color = self.theme.get(key_, "#00000000")
        if base_color.startswith("#"):
            base_color = base_color[1:]
        return f"#{base_color}{alpha_to_hex(alpha)}"


def deco(
    fg,
    bg=None,
    style="triangle",
    side="L",
    width=bar.CALCULATED,
    fontsize=24,
    fg_alpha=100,
    bg_alpha=100,
    **config,
):
    glyph = {
        "triangle": {
            "L": PLE["triangle"]["lower"]["R"],
            "R": PLE["triangle"]["upper"]["L"],
        },
        "circle": {
            "L": PLE["half_circle"]["R"],
            "R": PLE["half_circle"]["L"],
        },
        "divider": {
            "L": PLE["hard_divider_inverse"]["R"],
            "R": PLE["hard_divider_inverse"]["L"],
        },
    }
    return widget.TextBox(
        **{
            "text": f"{glyph[style][side]}",
            "foreground": resolve(fg, fg_alpha),
            "background": resolve(bg, bg_alpha),
            "width": width,
            "fontsize": fontsize,
            **config,
        }
    )


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
