-- just a comment
return {
  {
    "folke/twilight.nvim",
    opts = {
      context = -1,
    },
  },
  {
    "echasnovski/mini.hipatterns",
    version = "*",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
  {
    "echasnovski/mini.statusline",
    version = "*",
    config = function()
      local MiniStatusline = require("mini.statusline")
      local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
      local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
      MiniStatusline.section_mode = function(args)
        local modes = setmetatable({
          ["n"] = { long = "", short = "N", hl = "MiniStatuslineModeNormal" },
          ["v"] = { long = "󰸿", short = "V", hl = "MiniStatuslineModeVisual" },
          ["V"] = { long = "󰸽", short = "V-L", hl = "MiniStatuslineModeVisual" },
          [CTRL_V] = { long = "󰹀", short = "V-B", hl = "MiniStatuslineModeVisual" },
          ["s"] = { long = "", short = "S", hl = "MiniStatuslineModeVisual" },
          ["S"] = { long = "", short = "S-L", hl = "MiniStatuslineModeVisual" },
          [CTRL_S] = { long = "", short = "S-B", hl = "MiniStatuslineModeVisual" },
          ["i"] = { long = "", short = "I", hl = "MiniStatuslineModeInsert" },
          ["R"] = { long = "", short = "R", hl = "MiniStatuslineModeReplace" },
          ["c"] = { long = "󰑮", short = "C", hl = "MiniStatuslineModeCommand" },
          ["r"] = { long = "", short = "P", hl = "MiniStatuslineModeOther" },
          ["!"] = { long = "", short = "Sh", hl = "MiniStatuslineModeOther" },
          ["t"] = { long = "", short = "T", hl = "MiniStatuslineModeOther" },
        }, {
          __index = function()
            return { long = "Unknown", short = "", hl = "%#MiniStatuslineModeOther#" }
          end,
        })
        local mode_info = modes[vim.fn.mode()]
        local mode = MiniStatusline.is_truncated(args.trunc_width) and mode_info.short or mode_info.long
        return mode, mode_info.hl
      end
      MiniStatusline.setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
          inactive = function()
            return "%=%#MiniStatuslineInactive#%F%="
          end,
        },
        use_icons = true,
      })
      vim.cmd[[hi StatusLine guibg=NONE ctermbg=None]]
      vim.api.nvim_set_hl(0, "MiniStatusLineFilename", { link = "StatusLine" })
      for _, mode in ipairs({ "Normal", "Insert", "Visual", "Replace", "Command", "Other" }) do
        vim.api.nvim_set_hl(0, "MiniStatuslineMode" .. mode, { link = "StatusLine" })
      end
    end,
  },
}
