local runners = {
  c = "gcc % -o %:r && ./%:r",
  cpp = "g++ % -o %:r && ./%:r",
  go = "go run",
  javascript = "node",
  lua = "lua",
  python = "python3",
  ruby = "ruby",
  sh = "sh",
}

local function augroup(name)
  return vim.api.nvim_create_augroup("_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight on yank",
  callback = function()
    (vim.hl or vim.highlighht).on_yank()
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
  group = augroup("run_code"),
  pattern = "*",
  callback = function()
    local current_filetype = vim.bo.filetype
    local command = runners[current_filetype]
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
