local runners = {
  c = "gcc % -o %:r && ./%:r",
  cpp = "g++ % -o %:r && ./%:r",
  go = "go run %",
  javascript = "node %",
  lua = "lua %",
  python = "python3 %",
  ruby = "ruby %",
  sh = "sh %",
}

local function augroup(name)
  return vim.api.nvim_create_augroup("_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight on yank",
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

vim.api.nvim_create_autocmd("RecordingEnter", {
  group = augroup("recording_enter"),
  callback = function()
    vim.opt.cmdheight = 1
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  group = augroup("recording_leave"),
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("spell_lang"),
  pattern = { "markdown", "text" },
  callback = function (ev)
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "es" }
    local opts = { buffer = ev.buf, remap = false }
    vim.keymap.set("n", "<leader>st", "<Cmd>set spell!<CR>", opts)
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("run_code"),
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local command = runners[ft]
    pcall(vim.api.nvim_buf_del_keymap, 0, "n", "<C-A-j>")
    if command then
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<C-A-j>",
        ":w<CR>:split term://" .. command .. " %<CR>:resize 10<CR>",
        { noremap = true, silent = true, desc = "Execute file" }
      )
    end
  end,
})

local indent2 = { tabstop = 2, shiftwidth = 2, softtabstop = 2 }
local indent4 = { tabstop = 4, shiftwidth = 4, softtabstop = 4 }
local definitions = {
  { ft = { "astro", "html", "css", "javascript", "typescript", "md", "mdx" }, opts = indent2 },
  { ft = { "markdown" }, opts = { textwidth = 80 } },
  { ft = { "python", "go", "rust" }, opts = indent4 },
  {
    ft = { "lua" },
    opts = indent2,
    keys = {
      {
        "n",
        "<leader>rf",
        function()
          vim.cmd("luafile %")
        end,
        { desc = "Run Lua file" },
      },
    },
  },
}

local filetypes = {}
for _, def in ipairs(definitions) do
  for _, ft in ipairs(def.ft) do
    filetypes[ft] = def
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("user_filetypes"),
  callback = function(ev)
    local cfg = filetypes[ev.match]
    if not cfg then
      return
    end
    if cfg.opts then
      for opt, val in pairs(cfg.opts) do
        vim.opt_local[opt] = val
      end
    end
    if cfg.keys then
      for _, key in ipairs(cfg.keys) do
        local mode = key[1]
        local lhs = key[2]
        local rhs = key[3]
        local opts = key[4] or {}
        opts.buffer = ev.buf
        vim.keymap.set(mode, lhs, rhs, opts)
      end
    end
    if cfg.on_attach then
      cfg.on_attach(ev)
    end
  end,
})
