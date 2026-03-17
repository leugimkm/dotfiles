local M = { components = {}, opts = {} }
local config = {
  colors = { low = "#32302f", high = "#fabd2f" },
  limits = { size = 5242880, wordcount = 50000, max_chars = 10000 },
  filename = { max_width = 0.40, truncate = true },
  wordcount = { enabled = true, filetypes = { markdown = true, text = true, txt = true } },
  search = { enabled = true, maxcount = 500 },
  layout = { "filename", "mode_flags", "wordcount", "%=", "search", "fileinfo", "filesize", "%=", "position" },
  position = "default",
  sep = " ",
}

local function blend_fg_color(ratio)
  local hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  local fg = hl.fg or normal.fg or (vim.o.background == "dark" and 0xabb2bf or 0x383a42)
  local is_dark = vim.o.background == "dark"
  local r_mod = is_dark and ratio or (1 + ratio)
  local r = math.min(255, math.floor((fg / 65536) % 256) * r_mod)
  local g = math.min(255, math.floor((fg / 256) % 256) * r_mod)
  local b = math.min(255, math.floor(fg % 256) * r_mod)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function truncate(path, max_len)
  if vim.fn.strdisplaywidth(path) <= max_len then return path end
  local start = math.max(0, vim.fn.strchars(path) - max_len)
  return "…" .. vim.fn.strcharpart(path, start, max_len)
end

function M.setup_highlights()
  local set = vim.api.nvim_set_hl
  local c = M.opts.colors
  local dimmed = blend_fg_color(0.25)
  local inactive = blend_fg_color(0.15)
  for _, group in ipairs({ "StatusLine", "StatusLineTerm" }) do
    set(0, group, { fg = dimmed, bg = "NONE", ctermbg = "NONE" })
  end
  for _, group in ipairs({ "StatusLineNC", "StatusLineTermNC" }) do
    set(0, group, { fg = inactive, bg = "NONE", ctermbg = "NONE" })
  end
  for _, group in ipairs({ "MsgArea", "StatuslineSearch" }) do
    set(0, group, { fg = c.high, bg = "NONE", ctermbg = "NONE" })
  end
end

M.components.filename = function()
  if vim.bo.buftype ~= "" then return vim.fn.expand("%:t") end
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then return "[No Name]" end
  local relative = vim.fn.fnamemodify(name, ":~:.")
  if not M.opts.filename.truncate then return relative end
  local width = vim.api.nvim_win_get_width(0)
  local max_len = math.floor(width * M.opts.filename.max_width)
  return truncate(relative, max_len)
end

M.components.mode_flags = function() return "%m%r%h%w" end

M.components.wordcount = function()
  if not M.opts.wordcount.enabled then return "" end
  if not M.opts.wordcount.filetypes[vim.bo.filetype] then return "" end
  if vim.api.nvim_buf_line_count(0) > M.opts.limits.wordcount then return "" end
  local wc, max = vim.fn.wordcount(), M.opts.limits.max_chars
  local ws, cs = wc.words or 0, wc.chars or 0
  if cs > max then return string.format("%d/>%dk", ws, max / 1000) end
  return ws .. "/" .. cs
end

M.components.filesize = function()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then return "" end
  local ok, stat = pcall(vim.uv.fs_stat, name)
  if not ok or not stat then return "" end
  local sz = stat.size
  if sz > M.opts.limits.size then return string.format(">%dM", M.opts.limits.size / 1048576) end
  return (sz < 1024) and (sz .. "B")
    or (sz < 1048576) and string.format("%.1fK", sz / 1024)
    or string.format("%.1fM", sz / 1048576)
end

M.components.fileinfo = function()
  local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local fmt = vim.bo.fileformat
  return string.format("%s,%s", enc, fmt)
end

M.components.search = function()
  if not M.opts.search.enabled then return "" end
  if vim.v.hlsearch == 0 then return "" end
  if vim.fn.getreg("/") == "" then return "" end
  local sc = vim.fn.searchcount({ maxcount = M.opts.search.maxcount })
  if sc.total == 0 then return "" end
  local max_c = M.opts.search.maxcount
  local current = sc.current > max_c and ">" .. max_c or sc.current
  local total = sc.total > max_c and ">" .. max_c or sc.total
  return "%#StatuslineSearch#" .. current .. "/" .. total .. "%*"
end

M.components.position = function()
  if M.opts.position == "minimal" then return "%l:%v|%2p%%" end
  if M.opts.position == "compact" then return "%l:%L|%c:%{virtcol('$')-1}|%p%%" end
  return "%l:%L|%3v:%-3{virtcol('$')-1}| %3p%%"
end

function M.register_component(name, fn)
  if type(name) ~= "string" then error("Component name must be string") end
  if type(fn) ~= "function" then error("Component must be function") end
  M.components[name] = fn
end

function M.render()
  local res = {}
  local sep = M.opts.sep or " "
  for _, item in ipairs(M.opts.layout) do
    local ok, val = pcall(function()
      if M.components[item] then return M.components[item]() end
      if type(item) == "function" then return item() end
      return item
    end)
    if ok and val and val ~= "" then table.insert(res, val) end
  end
  local str = table.concat(res, sep)
  str = str:gsub("%s*%%=%s*", "%%=")
  return " " .. str .. " "
end

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", vim.deepcopy(config), user_opts or {})
  _G.Statusline = M
  M.setup_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = function() M.setup_highlights() end })
  vim.o.statusline = "%!v:lua.Statusline.render()"
end

return M
