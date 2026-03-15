local M = {}
local color = { low = "#3c3826", high = "#fabd2f" }
local MAX_CHARS = 10000

local function setup_highlights()
  vim.api.nvim_set_hl(0, "StatusLine", { fg = color.low, bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = color.low, bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea", { fg = color.high, bg = "NONE", ctermbg = "NONE" })
  for _, group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
    vim.api.nvim_set_hl(0, group, { fg = color.low })
  end
  -- vim.api.nvim_set_hl(0, "LineNr", { fg = color.high })
end

local function filename()
  local absolute_path = vim.api.nvim_buf_get_name(0)
  if absolute_path == "" then
    return "[No Name]"
  end
  local width = vim.api.nvim_win_get_width(0)
  local max_len = math.floor(width * 0.40)
  if vim.fn.strchars(absolute_path) <= max_len then
    return absolute_path
  end
  return " .." .. absolute_path:sub(-max_len)
end

local function update_counter()
  local ft = vim.bo.filetype
  if ft ~= "markdown" and ft ~= "text" and ft ~= "txt" then
    vim.b.counter = ""
    return
  end
  local winfo = vim.fn.wordcount()
  local wc = winfo.words or 0
  local cc = winfo.chars or 0
  if cc > MAX_CHARS then
    vim.b.counter = string.format("%d/>10k", wc)
    return
  end
  vim.b.counter = string.format("%d/%d", wc, cc)
end

local function counter()
  return vim.b.counter or ""
end

local function buffer_percentage()
  local line = vim.fn.line(".")
  local total = vim.fn.line("$")
  if total == 0 then
    return "  0%%"
  end
  local percent = math.floor((line / total) * 100)
  return string.format("%3d%%", percent)
end

local function buffer_size()
  local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
  if size <= 0 then
    return ""
  end
  if size < 1024 then
    return string.format("%dB", size)
  elseif size < 1048576 then
    return string.format("%.1fK", size / 1024)
  else
    return string.format("%.1fM", size / 1048576)
  end
end

local function fileinfo()
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local format = vim.bo.fileformat
  local size = buffer_size()
  return string.format("%s[%s] %s", encoding, format, size)
end

local function setup_counter_autocmd()
  local group = vim.api.nvim_create_augroup("StatusLineCounter", { clear = true })
  vim.api.nvim_create_autocmd(
    { "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI" },
    { group = group, callback = update_counter }
  )
end

local function search_count()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local ok, sc = pcall(vim.fn.searchcount, { recompute = true, maxcount = 9999 })
  if not ok or sc.current == nil or sc.total == 0 then
    return ""
  end
  if sc.incomplete == 1 then
    return "?/?"
  end
  local too_many = ">" .. sc.maxcount
  local current = sc.current > sc.maxcount and too_many or sc.current
  local total = sc.total > sc.maxcount and too_many or sc.total
  return current .. "/" .. total
end

local function setup_statusline()
  vim.opt.statusline = table.concat({
    " %{v:lua.require'config.statusline'.filename()} %m%r ",
    -- " %f%m%r|",  -- f: relative, F: absolute
    "%=",
    "%{v:lua.require'config.statusline'.fileinfo()} ",
    "%{v:lua.require'config.statusline'.counter()} ",
    "%{v:lua.require'config.statusline'.search_count()} ",
    "%l|%L|%2v|%-2{virtcol('$') - 1} ",
    "%{v:lua.require'config.statusline'.buffer_percentage()}",
  }, "")
end

M.filename = filename
M.fileinfo = fileinfo
M.buffer_percentage = buffer_percentage
M.counter = counter
M.search_count = search_count

function M.setup()
  setup_highlights()
  setup_counter_autocmd()
  setup_statusline()
end

return M
