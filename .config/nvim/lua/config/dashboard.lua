local M = {}
local state = {
  buf = nil,
  original = { global = {}, win = {} },
  layout = { art_w = 0, art_h = 0, footer = "" },
  cache = { w = 0, h = 0 },
}
local config = {
  art = {
    "▄▄▌  ▄▄▄ .▄• ▄▌ ▄▄ • ▪  • ▌ ▄ ·. ▄ •▄ • ▌ ▄ ·.",
    "██•  ▀▄.▀·█▪██▌▐█ ▀ ▪██ ·██ ▐███▪█▌▄▌▪·██ ▐███▪",
    "██▪  ▐▀▀▪▄█▌▐█▌▄█ ▀█▄▐█·▐█ ▌▐▌▐█·▐▀▀▄·▐█ ▌▐▌▐█·",
    "▐█▌▐▌▐█▄▄▌▐█▄█▌▐█▄▪▐█▐█▌██ ██▌▐█▌▐█.█▌██ ██▌▐█▌",
    ".▀▀▀  ▀▀▀  ▀▀▀ ·▀▀▀▀ ▀▀▀▀▀  █▪▀▀▀·▀  ▀▀▀  █▪▀▀▀",
  },
  global_opts = { laststatus = 0 },
  win_opts = {
    number = false,
    relativenumber = false,
    cursorline = false,
    colorcolumn = "",
    signcolumn = "no",
  },
  buffer_opts = {
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    filetype = "startscreen",
  },
}
M.config = {}

local function get_plugin_stats()
  local ok, lazy = pcall(require, "lazy")
  if not ok then return 0, 0, 0 end
  local s = lazy.stats()
  return s.loaded, s.count, s.startuptime
end

local function build_footer()
  local v = vim.version()
  local version = string.format("Neovim v%d.%d.%d", v.major, v.minor, v.patch)
  local loaded, total, time = get_plugin_stats()
  return string.format("%s | %d/%d plugins | %dms", version, loaded, total, time)
end

local function build_lines(cfg, layout, w, h)
  local lines = {}
  local vpad = math.max(0, math.floor((h - layout.art_h) / 2) - 1)
  local hpad = math.max(0, math.floor((w - layout.art_w) / 2))
  local indent = (" "):rep(hpad)
  for _ = 1, vpad do
    lines[#lines + 1] = ""
  end
  for _, line in ipairs(cfg.art) do
    lines[#lines + 1] = indent .. line
  end
  while #lines < h - 2 do
    lines[#lines + 1] = ""
  end
  local footer_w = vim.fn.strdisplaywidth(layout.footer)
  local footer_indent = string.rep(" ", math.max(0, math.floor((w - footer_w) / 2)))
  lines[#lines + 1] = ""
  lines[#lines + 1] = footer_indent .. layout.footer
  return lines
end

local function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then return end
  if vim.api.nvim_get_current_buf() ~= state.buf then return end
  local win = vim.api.nvim_get_current_win()
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)
  if state.cache.w == w and state.cache.h == h then return end
  state.cache.w, state.cache.h = w, h
  local lines = build_lines(M.config, state.layout, w, h)
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
end

local function apply_options()
  local win = vim.api.nvim_get_current_win()
  if next(state.original.win) == nil then
    for k, _ in pairs(M.config.win_opts) do
      state.original.win[k] = vim.wo[win][k]
    end
    state.original.laststatus = vim.o.laststatus
  end
  for k, v in pairs(M.config.win_opts) do
    vim.wo[win][k] = v
  end
  vim.o.laststatus = M.config.global_opts.laststatus
end

local function restore()
  local win = vim.api.nvim_get_current_win()
  if next(state.original.win) ~= nil and vim.api.nvim_win_is_valid(win) then
    for k, v in pairs(state.original.win) do
      vim.wo[win][k] = v
    end
  end
  if state.original.laststatus then vim.o.laststatus = state.original.laststatus end
end

local function set_keymaps()
  local DISABLED_KEYS = { "i", "a", "o", "O", "I", "A", "r", "R", "s", "S", "u" }
  for _, key in ipairs(DISABLED_KEYS) do
    vim.keymap.set("n", key, "<nop>", { buffer = state.buf, silent = true })
  end
end

function M.open()
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(state.buf)
  state.win = vim.api.nvim_get_current_win()
  for k, v in pairs(M.config.buffer_opts) do
    vim.bo[state.buf][k] = v
  end
  apply_options()
  set_keymaps()
  render()
  local group = vim.api.nvim_create_augroup("DashboardEvents", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", { buffer = state.buf, callback = render })
  vim.api.nvim_create_autocmd("BufEnter", { buffer = state.buf, group = group, callback = apply_options })
  vim.api.nvim_create_autocmd("BufLeave", { buffer = state.buf, group = group, callback = restore })
  vim.api.nvim_create_autocmd(
    "BufWipeout",
    { buffer = state.buf, once = true, callback = function() state.original.win = {} end }
  )
end

local function compute_layout()
  state.layout.art_w = vim.iter(M.config.art):map(vim.fn.strdisplaywidth):fold(0, math.max)
  state.layout.art_h = #M.config.art
  state.layout.footer = build_footer()
end

function M.setup(user_opts)
  M.config = vim.tbl_deep_extend("force", config, user_opts or {})
  compute_layout()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ui_start_screen", { clear = true }),
    once = true,
    callback = function()
      if vim.fn.argc() == 0 and vim.bo.filetype == "" then M.open() return end
      -- if vim.bo.filetype ~= "" then return end
      -- if vim.bo.buftype ~= "" then return end
      -- if vim.api.nvim_buf_get_name(0) ~= "" then return end
      -- if vim.bo.modified then return end
      -- M.open()
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyDone", "LazyVimStarted" },
    callback = function() render() end,
  })
end

return M
