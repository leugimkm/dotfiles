return {
  { "echasnovski/mini.trailspace", version = "*", opts = {} },
  {
    "echasnovski/mini.pairs",
    version = "*",
    opts = {
      mappings = {
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^||`].", register = { cr = false } },
      },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      fuzzy = { implementation = "prefer_rust" },
      signature = { enabled = true },
      sources = { default = { "lsp", "buffer", "snippets", "path", "omni" } },
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        menu = {
          border = "rounded",
          draw = { gap = 2 },
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
        documentation = {
          auto_show = false,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
        signature = {
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
