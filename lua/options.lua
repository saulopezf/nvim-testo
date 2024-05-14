require "nvchad.options"

-- Indenting
vim.cmd "set expandtab"
vim.cmd "set tabstop=4"
vim.cmd "set softtabstop=4"
vim.cmd "set shiftwidth=4"

-- Folding

-- Number of columns for the fold status
vim.o.foldcolumn = "0"

-- Max folding level (just set the max)
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Enable folding (of course)
vim.o.foldenable = true
vim.o.foldtext = ""

-- Characters to represent different statuses in the status column
--vim.o.fillchars = "foldopen:v,foldclose:>,foldsep: ,fold: "
