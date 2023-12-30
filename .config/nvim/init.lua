local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- style
	"arcticicestudio/nord-vim",
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	-- UI / General
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},
	{ "junegunn/fzf",                     dir = "~/.fzf", build = "./install --all" },
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end
	},
	-- Lsp
	{ "williamboman/mason.nvim" },
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x'
	},
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },
})

-- General setup

-- vim
vim.o.encoding = "utf-8"
vim.o.number = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4

vim.keymap.set("n", "<c-c>", "<ESC>:Neotree toggle<cr>")

-- style
vim.opt.termguicolors = true
vim.cmd.colorscheme('nord')
require("lualine").setup({
	options = { theme = 'nord' }
})


-- # fzf
vim.keymap.set("n", "<c-P>",
	"<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
require('fzf-lua').setup({ 'fzf-native' })

-- Autocomplete
local cmp = require('cmp')
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	})
})

-- #### LSP ###

-- install lsp automatically via mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "ruff_lsp" }
})

local lsp_zero = require('lsp-zero') -- lsp default
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	lsp_zero.buffer_autoformat()
end)
lsp_zero.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})

-- lua
require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())

-- rust
require('lspconfig').rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

-- python
require('lspconfig').pyright.setup({})
require('lspconfig').ruff_lsp.setup({})
