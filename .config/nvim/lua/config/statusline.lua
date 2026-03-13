local M = {}

local color = { low = "#3c3826", high = "#fabd2f" }

local function setup_highlights()
  vim.api.nvim_set_hl(0, "StatusLine", { fg = color.low, bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = color.low, bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea", { fg = color.high, bg = "NONE", ctermbg = "NONE" })
  for _, group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
    vim.api.nvim_set_hl(0, group, { fg = color.low })
  end
  -- vim.api.nvim_set_hl(0, "LineNr", { fg = color.high })
end

local function buffer_percentage()
  local line = vim.fn.line(".")
  local total = vim.fn.line("$")
  local percent = math.floor((line / total) * 100)
  return string.format("%3d%%", percent)
end

local function setup_statusline()
  vim.opt.statusline = table.concat({
    " %f %m",
    "%=",
    "%l|%L|%2v|%-2{virtcol('$') - 1}",
    "%{v:lua.require'config.statusline'.buffer_percentage()}",
  }, "")
end

M.buffer_percentage = buffer_percentage

function M.setup()
  setup_highlights()
  setup_statusline()
end

return M
