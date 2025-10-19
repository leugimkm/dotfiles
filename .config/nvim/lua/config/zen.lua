local M = { _active = false, _saved = {}, opts = {} }

local defaults = {
  keymaps = {
    zen = "<leader>tz",
    all = "<leader>ta",
    statusline = "<leader>tb",
    linenr = "<leader>tn",
    diagnostics = "<leader>td",
    virtuallines = "<leader>tl",
    virtualtext = "<leader>tt",
  },
  options = {
    laststatus = { on = 3, off = 0 },
    number = { on = true, off = false },
    relativenumber = { on = true, off = false },
    colorcolumn = { on = "80", off = "" },
    signcolumn = { on = "yes", off = "yes:3" },
  },
  diagnostics = { enable = true },
  twilight = { enable = true },
  custom_on = nil,
  custom_off = nil,
}

local function has_twilight()
  local ok, _ = pcall(require, "twilight")
  return ok
end

local function save_option(name)
  M._saved[name] = vim.opt[name]:get()
end

local function restore_option(name)
  local saved = M._saved[name]
  if saved ~= nil then
    vim.opt[name] = saved
  end
end

local function apply_option(name, state)
  local opt = M.opts.options[name]
  if opt then
    vim.opt[name] = opt[state and "on" or "off"]
  end
end

local function toggle_twilight(state)
  if not has_twilight() then
    return
  end
  if state then
    vim.cmd("TwilightEnable")
  else
    vim.cmd("TwilightDisable")
  end
end

local function enter()
  for name in pairs(M.opts.options) do
    save_option(name)
    apply_option(name, false)
  end

  if M.opts.diagnostics.enable then
    vim.diagnostic.enable(false)
  end

  if M.opts.twilight.enable then
    toggle_twilight(true)
  end

  if type(M.opts.custom_on) == "function" then
    M.opts.custom_on()
  end
end

local function exit()
  for name in pairs(M.opts.options) do
    restore_option(name)
  end

  if M.opts.diagnostics.enable then
    vim.diagnostic.enable(true)
  end

  if M.opts.twilight.enable then
    toggle_twilight(false)
  end

  if type(M.opts.custom_off) == "function" then
    M.opts.custom_off()
  end
end

function M.toggle()
  M._active = not M._active
  if M._active then
    enter()
  else
    exit()
  end
end

function M.toggle_option(name)
  if not M.opts.options[name] then
    return
  end

  local current = vim.opt[name]:get()
  local is_on = current == M.opts.options[name].on
  local new_state = not is_on

  apply_option(name, new_state)

  if name == "number" then
    apply_option("relativenumber", new_state)
    apply_option("colorcolumn", new_state)
    apply_option("signcolumn", new_state)
  end
end

function M.toggle_all()
  local status_on = vim.opt.laststatus:get() == M.opts.options.laststatus.on
  local new_state = not status_on

  apply_option("laststatus", new_state)
  M.toggle_option("number")

  local diag_state = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not diag_state)
end

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", defaults, user_opts or {})

  local km = M.opts.keymaps
  vim.keymap.set("n", km.zen, M.toggle, { desc = "Toggle zen mode" })
  vim.keymap.set("n", km.all, M.toggle_all, { desc = "Toggle all (statusline, lineNr, diagnostics)" })
  vim.keymap.set("n", km.statusline, function() M.toggle_option("laststatus") end, { desc = "Toggle statusline" })
  vim.keymap.set("n", km.linenr, function() M.toggle_option("number") end, { desc = "Toggle line numbers" })
  vim.keymap.set("n", km.diagnostics, function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = "Toggle diagnostics" })
  vim.keymap.set("n", km.virtuallines, function()
    local cfg = vim.diagnostic.config()
    vim.diagnostic.config({ virtual_lines = not cfg.virtual_lines })
  end, { desc = "Toggle diagnostic virtual_lines" })
  vim.keymap.set("n", km.virtualtext, function()
    local cfg = vim.diagnostic.config()
    vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
  end, { desc = "Toggle diagnostic virtual_text" })

  vim.api.nvim_create_user_command("ZenModeToggle", function()
    M.toggle()
  end, {})
end

return M
