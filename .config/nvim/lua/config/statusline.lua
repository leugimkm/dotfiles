local M = {}
local defaults = {
  colors = { low = "#3c3826", high = "#fabd2f" },
  max_chars = 10000,
  filename = { max_width = 0.40, truncate = true },
  wordcount = { enabled = true, throttle = 800, filetypes = { "markdown", "text", "txt" } },
  search = { enabled = true, maxcount = 500 },
  virtcol_limit = 500,
  filesize = { enabled = true },
}
M.opts = {}

function M.setup_highlights()
  local set = vim.api.nvim_set_hl
  local c = M.opts.colors
  set(0, "StatusLine", { fg = c.low, bg = "NONE", ctermbg = "NONE" })
  set(0, "StatusLineNC", { fg = c.low, bg = "NONE", ctermbg = "NONE" })
  set(0, "MsgArea", { fg = c.high, bg = "NONE", ctermbg = "NONE" })
  set(0, "StatuslineSearch", { fg = c.high, bg = "NONE" })
  for _, group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
    set(0, group, { fg = c.low })
  end
  -- set(0, "LineNr", { fg = c.high })
end

local function truncate_path(path, max_len)
  local utf_len = vim.fn.strchars(path)
  if utf_len <= max_len then return path end
  local start = math.max(0, utf_len - max_len)
  return "…" .. vim.fn.strcharpart(path, start, max_len)
end

local function update_filename()
  local b = vim.b
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    if b.stl_filename ~= "[No Name]" then b.stl_filename = "[No Name]" end
    return
  end
  local relative, width = vim.fn.fnamemodify(name, ":~:."), vim.api.nvim_win_get_width(0)
  local max_len = math.floor(width * M.opts.filename.max_width)
  local new_name = M.opts.filename.truncate and truncate_path(relative, max_len) or relative
  if b.stl_filename ~= new_name then b.stl_filename = new_name end
end

local function valid_ft(ft)
  for _, v in ipairs(M.opts.wordcount.filetypes) do
    if v == ft then return true end
  end
  return false
end

local function update_counter()
  local b = vim.b
  if not M.opts.wordcount.enabled then
    b.stl_counter = ""
    return
  end
  local ft = vim.bo.filetype
  if not valid_ft(ft) then
    b.stl_counter = ""
    return
  end
  local tick = vim.b.changedtick or 0
  local now = vim.uv.now()
  if b.stl_last_tick ~= tick or (now - (b.stl_last_count_time or 0) > M.opts.wordcount.throttle) then
    local wc = vim.fn.wordcount()
    b.stl_cache_words, b.stl_cache_chars = wc.words or 0, wc.chars or 0
    b.stl_last_count_time, b.stl_last_tick = now, tick
  end
  local words, chars = b.stl_cache_words or 0, b.stl_cache_chars or 0
  b.stl_counter = chars > M.opts.max_chars and string.format("%d/>%dk", words, M.opts.max_chars / 1000)
    or string.format("%d/%d", words, chars)
end

local function get_file_size()
  if not M.opts.filesize.enabled then return "" end
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then return "" end
  local ok, stat = pcall(vim.uv.fs_stat, name)
  if not ok or not stat or stat.size <= 0 then return "" end
  local size = stat.size
  if size < 1024 then return size .. "B" end
  if size < 1048576 then return string.format("%.1fK", size / 1024) end
  return string.format("%.1fM", size / 1048576)
end

function M.fileinfo()
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local format, size = vim.bo.fileformat, get_file_size()
  if size == "" then return string.format("%s[%s]", encoding, format) end
  return string.format("%s[%s] %s", encoding, format, size)
end

local function update_search_count()
  if not M.opts.search.enabled or vim.v.hlsearch == 0 or vim.fn.getreg("/") == "" then return end
  pcall(vim.fn.searchcount, { recompute = true, maxcount = M.opts.search.maxcount })
  vim.cmd("redrawstatus")
end

function M.search_count()
  if not M.opts.search.enabled or vim.v.hlsearch == 0 or vim.fn.mode() ~= "n" then return "" end
  local ok, sc = pcall(vim.fn.searchcount, { recompute = false, maxcount = M.opts.search.maxcount })
  if not ok or not sc or sc.total == 0 then return "" end
  if sc.incomplete == 1 then return "?/? " end
  local current = sc.current > sc.maxcount and ">" .. M.opts.search.maxcount or sc.current
  local total = sc.total > sc.maxcount and ">" .. M.opts.search.maxcount or sc.total
  return string.format("%s/%s ", current, total)
end

function M.safe_virt_len()
  local bytes = vim.fn.col("$") - 1
  if bytes > M.opts.virtcol_limit then return bytes end
  return vim.fn.virtcol("$") - 1
end

function M.setup_statusline()
  vim.opt.statusline = table.concat({
    -- "%{strlen(expand('%:p')) <= 40 ? expand('%:p') : expand('%:~:.')} %m%r%h%w ",
    " %{get(b:,'stl_filename','[No Name]')} %m%r%h%w ",
    "%{get(b:,'stl_counter','')}",
    "%=",
    "%#StatuslineSearch#%{v:lua.Statusline.search_count()}%*",
    "%{v:lua.Statusline.fileinfo()} ",
    "%l|%L|%2v|%-2{v:lua.Statusline.safe_virt_len()} %p%%",
  }, "")
end

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), user_opts or {})
  _G.Statusline = M
  M.setup_highlights()
  M.setup_statusline()
  local au = vim.api.nvim_create_augroup("CustomStatusline", { clear = true })
  vim.api.nvim_create_autocmd(
    { "BufEnter", "BufFilePost", "BufWinEnter", "BufWritePost", "VimResized", "WinResized" },
    { group = au, callback = update_filename }
  )
  vim.api.nvim_create_autocmd(
    { "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI", "InsertLeave" },
    { group = au, callback = update_counter }
  )
  vim.api.nvim_create_autocmd(
    { "CmdlineLeave" },
    { group = au, pattern = { "/", "?" }, callback = update_search_count }
  )
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { group = au, callback = update_search_count })
  vim.defer_fn(function()
    update_filename()
    update_counter()
  end, 50)
end

return M
