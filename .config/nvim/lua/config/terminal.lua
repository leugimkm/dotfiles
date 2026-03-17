local M = { state = { floating = { buf = -1, win = -1 } }, opts = {} }
local config = {
  width = 0.8,
  height = 0.8,
  border = "rounded",
  style = "minimal",
  relative = "editor",
  cmd = "Fterm",
  keys = { lhs = "<space>ot", opts = { noremap = true, silent = true } },
}

local function calculate(opts)
  local w, h = math.floor(vim.o.columns * opts.width), math.floor(vim.o.lines * opts.height)
  local r, c = math.floor((vim.o.lines - h) / 2), math.floor((vim.o.columns - w) / 2)
  return w, h, r, c
end

function M.create_floating_window(local_opts)
  local opts = vim.tbl_deep_extend("force", vim.deepcopy(M.state.opts), local_opts or {})
  local w, h, r, c = calculate(opts)
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win_config = {
    relative = opts.relative,
    width = w,
    height = h,
    col = c,
    row = r,
    style = opts.style,
    border = opts.border,
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  return { buf = buf, win = win }
end

function M.toggle_terminal()
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    M.state.floating = M.create_floating_window({ buf = M.state.floating.buf })
    if vim.bo[M.state.floating.buf].buftype ~= "terminal" then vim.cmd.terminal() end
    vim.cmd("startinsert")
  else
    vim.api.nvim_win_hide(M.state.floating.win)
  end
end

function M.setup(user_opts)
  M.state.opts = vim.tbl_deep_extend("force", vim.deepcopy(config), user_opts or {})
  local opts = M.state.opts
  vim.keymap.set({ "n", "t" }, opts.keys.lhs, M.toggle_terminal, opts.keys.opts)
  vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>", { desc = "Term: back to 'N' mode" })
  vim.api.nvim_create_user_command(opts.cmd, M.toggle_terminal, {})
end

return M
