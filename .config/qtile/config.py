import os
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy


@hook.subscribe.startup
def autostart():
    subprocess.run([os.path.expanduser('~/.config/qtile/autostart.sh')])


WALLPAPER = "~/pictures/wallpapers/00.jpg"
LOGO = "~/pictures/logos/aep_logo.png"
CUSTOM_TEXT = "ayudaenpython.com"
ICONS_PATH = "~/pictures/icons"
FONT = "SauceCodePro NF"
SIZE = 24
OPACITY = 1  # 0.9
MARGINS = [10, 10, 4, 10]  # [N, E, S, W]

BAR = "#282c34"
BLACK = "#29414f"
YELLOW = "#fac863"
KHAKI1 = "#ffff87"
GREY3 = "#080808"
GREY7 = "#121212"
TRUE_BLACK = "#000000"
TRANSPARENT = "#00000000"

PLE_LOWER_LEFT_TRIANGLE = '\ue0b8'
PLE_LOWER_RIGHT_TRIANGLE = '\ue0ba'
PLE_UPPER_LEFT_TRIANGLE = '\ue0bc'
PLE_UPPER_RIGHT_TRIANGLE = '\ue0be'
PLE_LEFT_HARD_DIVIDER_INVERSE = '\ue0d7'
PLE_RIGHT_HARD_DIVIDER_INVERSE = '\ue0d6'
PLE_LEFT_HALF_CIRCLE = '\ue0b6'
PLE_RIGHT_HALF_CIRCLE = '\ue0c5'
PLE_LEFT_FLAME = '\ue0c2'
PLE_RIGHT_FLAME = '\ue0c0'
PLE_LEFT_PIXELATED_SQUARES_BIG = '\ue0c7'
PLE_RIGHT_PIXELATED_SQUARES_BIG = '\ue0c6'
PLE_LEFT_PIXELATED_SQUARES_SMALL = '\ue0c5'
PLE_RIGHT_PIXELATED_SQUARES_SMALL = '\ue0c4'

BLACK_MEDIUM_LEFT_POINTING_TRIANGLE = '\u23f4'
BLACK_MEDIUM_RIGHT_POINTING_TRIANGLE = '\u23f5'
BLACK_RIGHT_POITING_TRIANGLE = '\u25b6'
BLACK_LEFT_POITING_TRIANGLE = '\u25c0'
BLACK_LOWER_RIGHT_TRIANGLE = '\u25e2'
BLACK_LOWER_LEFT_TRIANGLE = '\u25e3'
BLACK_UPPER_LEFT_TRIANGLE = '\u25e4'
BLACK_UPPER_RIGHT_TRIANGLE = '\u25e5'
LEFT_HALF_BLACK_CIRCLE = '\u25d6'
RIGHT_HALF_BLACK_CIRCLE = '\u25d7'

LABELS = [
    '\U000f0f0f',
    '\U000f0f10',
    '\U000f0f11',
    '\U000f0f12',
    '\U000f0f13',
    '\U000f0f14',
]

mod = "mod4"
terminal = "kitty"

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to L"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to R"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus D"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus U"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move W: L"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move W: R"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move W: D"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move W: U"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow W: L"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow W: R"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow W: D"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow W: U"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all W sizes"),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split/unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused W"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused W"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused W"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard()),
]

groups = [
    Group("1", label=LABELS[0], layout="bsp"),
    Group("2", label=LABELS[1], layout="monadtall"),
    Group("3", label=LABELS[2], layout="monadtall"),
    Group("4", label=LABELS[3], layout="monadtall"),
    Group("5", label=LABELS[4], layout="floating"),
    Group("6", label=LABELS[5], layout="floating"),
]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to G {}".format(i.name)),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc="Switch to & move focused W to G {}".format(i.name)),
    ])

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
    # layout.Max(),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font=FONT,
    fontsize=12,
    padding=4,
    background=GREY3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
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
                    padding=0,
                ),
                widget.TextBox(
                    text=CUSTOM_TEXT,
                    foreground=KHAKI1,
                    background=TRUE_BLACK,
                    padding=0,
                ),
                widget.TextBox(
                    text=PLE_LOWER_RIGHT_TRIANGLE,
                    foreground=GREY3,
                    background=TRUE_BLACK,
                    fontsize=24,
                    padding=0,
                ),
                widget.GroupBox(
                    highlight_color=[GREY7, GREY7],
                    highlight_method="line",
                    active=[YELLOW, YELLOW],
                    this_current_screen_border=[YELLOW, YELLOW],
                ),
                widget.TextBox(
                    text=PLE_UPPER_LEFT_TRIANGLE,
                    fontsize=24,
                    foreground=GREY3,
                    background=TRANSPARENT,
                    padding=0,
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
                    padding=0,
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser(ICONS_PATH)],
                    foreground=YELLOW,
                    background=TRUE_BLACK,
                    padding=2,
                    scale=0.5,
                ),
                widget.CurrentLayout(
                    foreground=YELLOW,
                    background=TRUE_BLACK,
                    padding=2,
                ),
                widget.TextBox(
                    text=PLE_LOWER_RIGHT_TRIANGLE,
                    foreground=YELLOW,
                    background=TRUE_BLACK,
                    fontsize=24,
                    padding=0,
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
                    padding=0,
                ),
                widget.Clock(
                    foreground=YELLOW,
                    background=GREY3,
                    padding=2,
                    format="%d/%m/%Y %a %I:%M %p",
                ),
                widget.TextBox(
                    text=PLE_LOWER_RIGHT_TRIANGLE,
                    foreground=TRUE_BLACK,
                    background=GREY3,
                    fontsize=24,
                    padding=0,
                ),
                widget.QuickExit(
                    foreground=YELLOW,
                    background=TRUE_BLACK,
                    padding=2,
                    default_text="exit",
                ),
                widget.TextBox(
                    text=PLE_UPPER_LEFT_TRIANGLE,
                    fontsize=24,
                    foreground=TRUE_BLACK,
                    background=TRANSPARENT,
                    padding=0,
                ),
            ],
            size=SIZE,
            background=TRANSPARENT,
            opacity=OPACITY,
            margin=MARGINS,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button1", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
# floats_kept_above = True
cursor_warp = False
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
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

wmname = "Qtile"
