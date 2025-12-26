require "nvchad.options"

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Enforce 2-space indents on all filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

local o = vim.opt
-- add yours here!
o.termguicolors = true  -- Enable true color support
o.guicursor = "i-n-c-sm:block-blinkwait700-blinkon400-blinkoff250"

--
-- CursorLine
-- o.cursorline = true
-- o.cursorlineopt ='both' -- to enable cursorline!
-- vim.cmd([[
--   highlight CursorLine ctermbg=DarkGrey guibg=#2a2a2a
--   highlight CursorLineNr ctermbg=DarkGrey guibg=#2a2a2a
-- ]])
--
--
-- o.number = true         -- Show absolute line number
o.relativenumber = true -- Show relative numbers
