vim.o.termguicolors = true
vim.o.background = 'light'
vim.cmd('colorscheme lucius')

vim.g.lightline = {
	colorscheme = 'one'
}

vim.o.smartindent = true
vim.o.cmdheight = 2
vim.o.updatetime = 150
vim.o.scrolloff = 9999
vim.g.scrollfix = 50
vim.o.signcolumn = 'yes'
vim.o.number = true
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.wildmenu = true
vim.o.inccommand = 'nosplit'
vim.o.clipboard = 'unnamed'
vim.o.foldmethod = 'syntax'
vim.opt.path:append '**'


vim.g.mapleader = ' '
vim.api.nvim_set_keymap('i', 'kl', '<Esc>', { noremap = false, silent = true })

modes = {'n', 'v', 'o'}
function map_for_modes(lhs, rhs)
	for _, m in ipairs(modes) do
		vim.api.nvim_set_keymap(m, lhs, rhs, { noremap = true, silent = true })
	end
end
map_for_modes('j', 'h')
map_for_modes('k', 'j')
map_for_modes('l', 'k')
map_for_modes(';', 'l')


vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>f', ':GFiles', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>af', ':Files', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>s', ':Rg', { noremap = true, silent = true })
