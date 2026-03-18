local M = {}
local state =
  { buf = nil, g_original = {}, w_original = {}, art_w = 0, art_h = 0, footer = "", last = { w = 0, h = 0 } }
local config = {
  art = {
    "▄▄▌  ▄▄▄ .▄• ▄▌ ▄▄ • ▪  • ▌ ▄ ·. ▄ •▄ • ▌ ▄ ·.",
    "██•  ▀▄.▀·█▪██▌▐█ ▀ ▪██ ·██ ▐███▪█▌▄▌▪·██ ▐███▪",
    "██▪  ▐▀▀▪▄█▌▐█▌▄█ ▀█▄▐█·▐█ ▌▐▌▐█·▐▀▀▄·▐█ ▌▐▌▐█·",
    "▐█▌▐▌▐█▄▄▌▐█▄█▌▐█▄▪▐█▐█▌██ ██▌▐█▌▐█.█▌██ ██▌▐█▌",
    ".▀▀▀  ▀▀▀  ▀▀▀ ·▀▀▀▀ ▀▀▀▀▀  █▪▀▀▀·▀  ▀▀▀  █▪▀▀▀",
  },
  global_opts = { laststatus = 0 },
  win_opts = { number = false, relativenumber = false, cursorline = false, colorcolumn = "" },
  buffer_opts = {
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = false,
    readonly = true,
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
  return string.format("%s  |  %d/%d plugins |  %dms", version, loaded, total, time)
end

local function build_lines(w, h)
  local lines = {}
  local vpad = math.max(0, math.floor((h - state.art_h) / 2) - 1)
  local hpad = math.max(0, math.floor((w - state.art_w) / 2))
  local indent = string.rep(" ", hpad)
  for _ = 1, vpad do
    lines[#lines + 1] = ""
  end
  for _, line in ipairs(M.config.art) do
    lines[#lines + 1] = indent .. line
  end
  while #lines < h - 2 do
    lines[#lines + 1] = ""
  end
  local footer_w = vim.fn.strdisplaywidth(state.footer)
  local footer_indent = string.rep(" ", math.max(0, math.floor((w - footer_w) / 2)))
  lines[#lines + 1] = ""
  lines[#lines + 1] = footer_indent .. state.footer
  return lines
end

local function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then return end
  if vim.api.nvim_get_current_buf() ~= state.buf then return end
  local win = vim.api.nvim_get_current_win()
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)
  if state.last.w == w and state.last.h == h then return end
  state.last = { w = w, h = h }
  local lines = build_lines(w, h)
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
end

local function apply()
  local win = vim.api.nvim_get_current_win()
  for k, v in pairs(M.config.buffer_opts) do
    vim.bo[state.buf][k] = v
  end
  for k, v in pairs(M.config.win_opts) do
    state.w_original[k] = vim.wo[win][k]
    vim.wo[win][k] = v
  end
  for k, v in pairs(M.config.global_opts) do
    state.g_original[k] = vim.o[k]
    vim.o[k] = v
  end
end

local function restore()
  for k, v in pairs(state.g_original) do
    vim.o[k] = v
  end
  local win = vim.api.nvim_get_current_win()
  for k, v in pairs(state.w_original or {}) do
    vim.wo[win][k] = v
  end
end

local function set_keymaps()
  local blocked = { "i", "a", "o", "O", "I", "A", "r", "R", "s", "S", "u" }
  for _, key in ipairs(blocked) do
    vim.keymap.set("n", key, "<nop>", { buffer = state.buf, silent = true })
  end
end

function M.open()
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(state.buf)
  apply()
  set_keymaps()
  render()
  vim.api.nvim_create_autocmd("VimResized", { buffer = state.buf, callback = render })
  vim.api.nvim_create_autocmd({ "BufWipeout" }, { buffer = state.buf, once = true, callback = restore })
end

function M.setup(user_opts)
  M.config = vim.tbl_deep_extend("force", config, user_opts or {})
  state.art_w = vim.iter(M.config.art):map(vim.fn.strdisplaywidth):fold(0, math.max)
  state.art_h = #M.config.art
  state.footer = build_footer()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ui_start_screen", { clear = true }),
    once = true,
    callback = function()
      if vim.fn.argc() > 0 then return end
      if vim.bo.filetype ~= "" then return end
      if vim.bo.buftype ~= "" then return end
      if vim.api.nvim_buf_get_name(0) ~= "" then return end
      if vim.bo.modified then return end
      M.open()
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyDone", "LazyVimStarted" },
    callback = function() render() end,
  })
end

return M
