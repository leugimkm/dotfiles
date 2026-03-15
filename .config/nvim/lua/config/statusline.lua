local M = {}

local defaults = {
  color = { low = "#3c3826", high = "#fabd2f" },
  max = 10000,
}

M.opts = {}

function M.setup_highlights()
  vim.api.nvim_set_hl(0, "StatusLine", { fg = M.opts.color.low, bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = M.opts.color.low, bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea", { fg = M.opts.color.high, bg = "NONE", ctermbg = "NONE" })
  for _, group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
    vim.api.nvim_set_hl(0, group, { fg = M.opts.color.low })
  end
  -- vim.api.nvim_set_hl(0, "LineNr", { fg = M.opts.color.high })
end

local function update_filename()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.b.stl_filename = "[No Name]"
    return
  end
  local width = vim.api.nvim_win_get_width(0)
  local max_len = math.floor(width * 0.40)
  if vim.fn.strchars(path) <= max_len then
    vim.b.stl_filename = path
    return
  end
  vim.b.stl_filename = "…" .. path:sub(-max_len)
end

function M.filename()
  return vim.b.stl_filename or ""
end

local function update_counter()
  local ft = vim.bo.filetype
  if ft ~= "markdown" and ft ~= "text" and ft ~= "txt" then
    vim.b.counter = ""
    return
  end
  local max = M.opts.max
  local winfo = vim.fn.wordcount()
  local wc = winfo.words or 0
  local cc = winfo.chars or 0
  if cc > max then
    vim.b.counter = string.format("%d/>10k", wc)
    return
  end
  vim.b.counter = string.format("%d/%d", wc, cc)
end

function M.counter()
  return vim.b.counter or ""
end

function M.buffer_percentage()
  local line = vim.fn.line(".")
  local total = vim.fn.line("$")
  if total == 0 then
    return "  0%%"
  end
  local percent = math.floor((line / total) * 100)
  return string.format("%3d%%", percent)
end

local function buffer_size()
  local name = vim.api.nvim_buf_get_name(0)
  local size = vim.fn.getfsize(name)
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

function M.fileinfo()
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local format = vim.bo.fileformat
  local size = buffer_size()
  return string.format("%s[%s] %s", encoding, format, size)
end

function M.search_count()
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

function M.setup_filename_autocmd()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost", "BufWinEnter", "VimResized", "WinResized" }, {
    group = vim.api.nvim_create_augroup("StatusLineFilename", { clear = true }),
    callback = update_filename,
  })
end

function M.setup_counter_autocmd()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI" }, {
    group = vim.api.nvim_create_augroup("StatusLineCounter", { clear = true }),
    callback = update_counter,
  })
end

function M.safe_virt_len()
  local col = vim.fn.col("$") - 1
  if col > 500 then
    return col
  end
  return vim.fn.virtcol("$") - 1
end

function M.setup_statusline()
  vim.opt.statusline = table.concat({
    " %{v:lua.Statusline.filename()} %m%r ",
    -- " %f%m%r|",  -- f: relative, F: absolute
    "%=",
    "%{v:lua.Statusline.fileinfo()} ",
    "%{v:lua.Statusline.counter()} ",
    "%{v:lua.Statusline.search_count()} ",
    "%l|%L|%2v|%-2{v:lua.Statusline.safe_virt_len()} ",
    -- "%l|%L|%2v|%-2{virtcol('$') - 1} ",
    "%{v:lua.Statusline.buffer_percentage()}",
  }, "")
end

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", defaults, user_opts or {})
  _G.Statusline = M
  M.setup_highlights()
  M.setup_counter_autocmd()
  M.setup_filename_autocmd()
  M.setup_statusline()
end

return M
