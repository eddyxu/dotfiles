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
	{
		'nanozuki/tabby.nvim',
		event = 'VimEnter',
		dependencies = 'nvim-tree/nvim-web-devicons',
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
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua", "vim", "vimdoc", "rust", "python", "bash" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
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
	{ 'L3MON4D3/LuaSnip' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp-signature-help' },
	{ 'saadparwaiz1/cmp_luasnip' },
	-- Rust
	{
		'mrcjkb/rustaceanvim',
		version = '^3', -- Recommended
		ft = { 'rust' },
	},
	{
		'saecki/crates.nvim',
		tag = 'stable',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('crates').setup()
		end,
	},
})

-- General setup

-- vim
vim.o.encoding = "utf-8"
vim.o.number = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*",
	command = [[:%s/\s\+$//e]],
})

vim.keymap.set("n", "<c-c>", "<ESC>:Neotree toggle<cr>")

-- style
vim.opt.showtabline = 2
vim.opt.termguicolors = true
vim.cmd.colorscheme('nord')
require("lualine").setup({
	options = { theme = 'nord' }
})
require('tabby.tabline').use_preset('active_wins_at_tail', {})


-- # fzf
vim.keymap.set("n", "<c-P>",
	"<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<c-L>",
	"<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true })
require('fzf-lua').setup({ 'fzf-native' })

-- Autocomplete
local cmp = require('cmp')
local luasnip = require('luasnip')

local cmp_has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	},
	mapping = cmp.mapping.preset.insert({
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif cmp_has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources(
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer', keyword_length = 3 },
		{ name = 'path' }
	),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lsp_signature_help = "[SIG]",
				luasnip = "[SNIP]",
				buffer = "[BUF]",
				path = "[PATH]",
			})[entry.source.name]
			return vim_item
		end
	}
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()


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

-- python
local on_attach_ruff = function(client, bufnr)
	client.server_capabilities.hoverProvider = false
end
require('lspconfig').pyright.setup({ cappacities = capabilities })
require('lspconfig').ruff_lsp.setup({
	on_attach = on_attach_ruff,
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = { "--preview" },
		}
	}
})
