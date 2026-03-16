local M = {}
local defaults = {
  colors = { low = "#3c3826", high = "#fabd2f" },
  max_chars = 10000,
  filename = { max_width = 0.40, truncate = true },
  wordcount = { enabled = true, throttle = 800, filetypes = { markdown = true, text = true, txt = true } },
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
  local width = vim.fn.strdisplaywidth(path)
  if width <= max_len then return path end
  local start = math.max(0, vim.fn.strchars(path) - max_len)
  return "…" .. vim.fn.strcharpart(path, start, max_len)
end

local function update_filename()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    vim.b.stl_filename = "[No Name]"
    return
  end
  local relative, width = vim.fn.fnamemodify(name, ":~:."), vim.api.nvim_win_get_width(0)
  local max_len = math.floor(width * M.opts.filename.max_width)
  vim.b.stl_filename = M.opts.filename.truncate and truncate_path(relative, max_len) or relative
end

local function update_counter()
  local ft = vim.bo.filetype
  if not M.opts.wordcount.enabled or not M.opts.wordcount.filetypes[ft] then
    vim.b.stl_counter = ""
    return
  end
  local b = vim.b
  local tick = vim.b.changedtick
  local now = vim.uv.now()
  if tick ~= b.stl_last_tick or (now - (b.stl_last_count_time or 0) > M.opts.wordcount.throttle) then
    local wc = vim.fn.wordcount()
    b.stl_cache_words, b.stl_cache_chars = wc.words or 0, wc.chars or 0
    b.stl_last_count_time, b.stl_last_tick = now, tick
  end
  local words, chars = b.stl_cache_words or 0, b.stl_cache_chars or 0
  b.stl_counter = chars > M.opts.max_chars and string.format("%d/>%dk", words, M.opts.max_chars / 1000)
    or string.format("%d/%d", words, chars)
end

local function update_filesize()
  local name = vim.api.nvim_buf_get_name(0)
  if not M.opts.filesize or not M.opts.filesize.enabled or name == "" then
    vim.b.stl_filesize = ""
    return
  end
  local ok, stat = pcall(vim.uv.fs_stat, name)
  if not ok or not stat or stat.size <= 0 then
    vim.b.stl_filesize = ""
    return
  end
  local size = stat.size
  vim.b.stl_filesize = (size < 1024) and (size .. "B")
    or (size < 1048576) and string.format("%.1fK", size / 1024)
    or string.format("%.1fM", size / 1048576)
end

local function update_fileinfo()
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local format, size = vim.bo.fileformat, vim.b.stl_filesize or ""
  vim.b.stl_fileinfo = size == "" and string.format("%s[%s]", encoding, format)
    or string.format("%s[%s] %s", encoding, format, size)
end

local function update_search()
  if not M.opts.search.enabled or vim.hlsearch == 0 or vim.fn.getreg("/") == "" then
    vim.b.stl_search = ""
    return
  end
  local max_c = M.opts.search.maxcount
  local ok, sc = pcall(vim.fn.searchcount, { recompute = true, maxcount = max_c })
  if not ok or not sc or sc.total == 0 then
    vim.b.stl_search = ""
    return
  end
  if sc.incomplete == 1 then
    vim.b.stl_search = "?/? "
    return
  end
  local current = sc.current > max_c and ">" .. max_c or sc.current
  local total = sc.total > max_c and ">" .. max_c or sc.total
  vim.b.stl_search = current .. "/" .. total .. " "
end

local function update_virtcol()
  local limit = M.opts.virtcol_limit
  local bytes = vim.fn.col("$") - 1
  vim.b.stl_virtcol = bytes > limit and bytes or vim.fn.virtcol("$") - 1
end

function M.setup_statusline()
  vim.opt.statusline = table.concat({
    -- "%{strlen(expand('%:p')) <= 40 ? expand('%:p') : expand('%:~:.')} %m%r%h%w ",
    " %{get(b:,'stl_filename','[No Name]')} %m%r%h%w ",
    "%{get(b:,'stl_counter','')}",
    "%=",
    "%#StatuslineSearch#%{get(b:,'stl_search','')}%*",
    "%{get(b:,'stl_fileinfo','')} ",
    "%l|%L|%2v|%-2{get(b:,'stl_virtcol','0')} %p%%",
  }, "")
end

function M.statusline_update(event)
  if event == "BufEnter" or event == "BufWritePost" or event == "WinResized" then
    update_filename()
    update_filesize()
    update_fileinfo()
  end
  if event == "TextChanged" or event == "TextChangedI" or event == "InsertLeave" then update_counter() end
  if event == "CursorMoved" or event == "CursorMovedI" then
    update_search()
    update_counter()
    update_virtcol()
  end
end

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), user_opts or {})
  _G.Statusline = M
  M.setup_highlights()
  M.setup_statusline()
  local au = vim.api.nvim_create_augroup("CustomStatusline", { clear = true })
  local events = {
    "BufEnter",
    "BufFilePost",
    "BufWritePost",
    "CursorMoved",
    "CursorMovedI",
    "InsertLeave",
    "TextChanged",
    "TextChangedI",
    "WinResized",
  }
  for _, event in ipairs(events) do
    vim.api.nvim_create_autocmd(event, { group = au, callback = function() M.statusline_update(event) end })
  end
  vim.api.nvim_create_autocmd({ "CmdlineLeave" }, { group = au, pattern = { "/", "?" }, callback = update_search })
  vim.defer_fn(function()
    M.statusline_update("BufEnter")
    M.statusline_update("TextChanged")
  end, 50)
end

return M
