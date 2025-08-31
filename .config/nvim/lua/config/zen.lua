local M = { _active = false, _saved = {}, opts = {} }

local defaults = {
  keymap = "<leader>tz",
  laststatus = { on = 3, off = 0 },
  number = { on = true, off = false },
  relativenumber = { on = true, off = false },
  colorcolumn = { on = "80", off = "" },
  diagnostics = { enable = true },
  twilight = { enable = false },
  custom_on = nil,
  custom_off = nil,
}

local function save(name)
  M._saved[name] = vim.opt[name]:get()
end

local function restore(name)
  if M._saved[name] ~= nil then
    vim.opt[name] = M._saved[name]
  end
end

local function enter()
  if not M._saved.laststatus then
    for _, o in ipairs({ "laststatus", "number", "relativenumber", "colorcolumn" }) do
      save(o)
    end
  end
  vim.opt.laststatus = M.opts.laststatus.off
  vim.opt.number = M.opts.number.off
  vim.opt.relativenumber = M.opts.relativenumber.off
  vim.opt.colorcolumn = M.opts.colorcolumn.off
  if M.opts.diagnostics.enable then
    M.opts.diagnostics.enable = false
    vim.diagnostic.enable(false, nil)
  end
  if not M.opts.twilight.enable then
    M.opts.twilight.enable = true
    vim.cmd("TwilightEnable")
  end
  if type(M.opts.custom_on) == "function" then
    M.opts.custom_on()
  end
end

local function exit()
  for _, o in ipairs({ "laststatus", "number", "relativenumber", "colorcolumn" }) do
    restore(o)
  end
  if not M.opts.diagnostics.enable then
    M.opts.diagnostics.enable = true
    vim.diagnostic.enable(true, nil)
  end
  if M.opts.twilight.enable then
    M.opts.twilight.enable = false
    vim.cmd("TwilightDisable")
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

function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", defaults, user_opts or {})
  vim.keymap.set("n", M.opts.keymap, M.toggle, { noremap = true, silent = true, desc = "Toggle zen mode" })
end

return M
