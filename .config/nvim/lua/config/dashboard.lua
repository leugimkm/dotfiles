local M = {}
local state = { buf = nil, original_globals = {}, art_width = 0, footer = "" }
local defaults = {
  art = {
    "▄▄▌  ▄▄▄ .▄• ▄▌ ▄▄ • ▪  • ▌ ▄ ·. ▄ •▄ • ▌ ▄ ·.",
    "██•  ▀▄.▀·█▪██▌▐█ ▀ ▪██ ·██ ▐███▪█▌▄▌▪·██ ▐███▪",
    "██▪  ▐▀▀▪▄█▌▐█▌▄█ ▀█▄▐█·▐█ ▌▐▌▐█·▐▀▀▄·▐█ ▌▐▌▐█·",
    "▐█▌▐▌▐█▄▄▌▐█▄█▌▐█▄▪▐█▐█▌██ ██▌▐█▌▐█.█▌██ ██▌▐█▌",
    ".▀▀▀  ▀▀▀  ▀▀▀ ·▀▀▀▀ ▀▀▀▀▀  █▪▀▀▀·▀  ▀▀▀  █▪▀▀▀",
  },
  global_opts = { laststatus = 0 },
  buffer_opts = {
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = false,
    readonly = true,
    number = false,
    relativenumber = false,
    cursorline = false,
    colorcolumn = "",
    filetype = "startscreen",
  },
}
M.config = {}

local function computer_art_width()
  local width = 0
  for _, line in ipairs(M.config.art) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  state.art_width = width
end

local function get_plugin_stats()
  local ok, lazy = pcall(require, "lazy")
  if not ok then return 0, 0, 0 end
  local stats = lazy.stats()
  return stats.loaded, stats.count, stats.startuptime
end

local function get_footer()
  local v = vim.version()
  local version = string.format("Neovim v%d.%d.%d", v.major, v.minor, v.patch)
  local loaded, installed, time = get_plugin_stats()
  return string.format("%s  |  %d/%d plugins |  %dms", version, loaded, installed, time)
end

local function render()
  if not vim.api.nvim_buf_is_valid(state.buf) then return end
  local win = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)
  local lines = {}
  local art = M.config.art
  local art_height = #art
  local art_width = state.art_width
  local footer = state.footer
  local footer_width = vim.fn.strdisplaywidth(footer)
  local vertical_padding = math.max(0, math.floor((height - art_height) / 2) - 1)
  local horizontal_padding = math.max(0, math.floor((width - art_width) / 2))
  local indent = string.rep(" ", horizontal_padding)
  for _ = 1, vertical_padding do
    lines[#lines + 1] = ""
  end
  for _, line in ipairs(art) do
    lines[#lines + 1] = indent .. line
  end
  while #lines < height - 2 do
    lines[#lines + 1] = ""
  end
  local footer_indent = string.rep(" ", math.max(0, math.floor((width - footer_width) / 2)))
  lines[#lines + 1] = ""
  lines[#lines + 1] = footer_indent .. footer
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
end

local function restore_globals()
  for k, v in pairs(state.original_globals) do
    vim.o[k] = v
  end
end

function M.open()
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(state.buf)
  for k, v in pairs(M.config.global_opts) do
    state.original_globals[k] = vim.o[k]
    vim.o[k] = v
  end
  for k, v in pairs(M.config.buffer_opts) do
    vim.api.nvim_buf_set_option(state.buf, k, v)
  end
  render()
  vim.api.nvim_create_autocmd("VimResized", { buffer = state.buf, callback = render })
  vim.api.nvim_create_autocmd("BufUnload", { buffer = state.buf, once = true, callback = restore_globals })
  local blocked = { "i", "a", "o", "O", "I", "A", "r", "R", "s", "S", "u" }
  for _, key in ipairs(blocked) do
    vim.keymap.set("n", key, "<nop>", { buffer = state.buf, silent = true })
  end
end

function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", defaults, opts)
  computer_art_width()
  state.footer = get_footer()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ui_start_screen", { clear = true }),
    once = true,
    callback = function()
      if vim.fn.argc() ~= 0 then return end
      if vim.api.nvim_buf_get_name(0) ~= "" then return end
      if vim.bo.modified then return end
      M.open()
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      state.footer = get_footer()
      if state.buf and vim.api.nvim_buf_is_valid(state.buf) then render() end
    end,
  })
end

return M
