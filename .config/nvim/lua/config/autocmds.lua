local function augroup(name)
  return vim.api.nvim_create_augroup("_" .. name, { clear = true})
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight on yank",
  callback = function()
    (vim.hl or vim.highlighht).on_yank()
  end
})

vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function ()
    vim.opt.cmdheight = 1
  end
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function ()
    vim.opt.cmdheight = 0
  end
})
