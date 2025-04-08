---- ... ----
---- ... ----
-- ... --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---- ... ----
-- Tab indentation settings (make tabs 4 spaces). --
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- Line numbering settings. --
vim.opt.number = true
vim.opt.relativenumber = true

-- Load Lazy to manage all NeoVim plugins. --
require("config.lazy")
