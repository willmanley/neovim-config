---- This is the file that is ran upon NeoVim initialisation! ----
---- Set custom global vim keybindings. ----
-- Set the global <leader> key to space bar. --
vim.g.mapleader = " "

---- Set global key action modifications. ----
-- Tab indentation settings (make tabs 4 spaces). --
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Line numbering settings. --
vim.opt.number = true
vim.opt.relativenumber = true

---- Load all NeoVim plugins & their configurations. ----
-- Load Lazy to manage all NeoVim plugins. --
require("config.lazy")
