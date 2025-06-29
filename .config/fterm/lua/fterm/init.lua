local M = {}

M.state = { floating = { buf = -1, win = -1, } }

function M.create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then buf = opts.buf
  else buf = vim.api.nvim_create_buf(false, true)
  end
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = opts.border or "rounded",
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

function M.toggle_terminal()
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    M.state.floating = M.create_floating_window { buf = M.state.floating.buf }
    if vim.bo[M.state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else vim.api.nvim_win_hide(M.state.floating.win)
  end
end

function M.setup(opts)
  opts = opts or {}
  vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>")
  local keymap = opts.keymap or { mode = "n", lhs = "<space>ft", opts = { noremap = true, silent = true}}
  vim.keymap.set(keymap.mode, keymap.lhs, M.toggle_terminal, keymap.opts)
  local cmd_name = opts.commmand or "Fterm"
  vim.api.nvim_create_user_command(cmd_name, M.toggle_terminal, {})
end

return M
