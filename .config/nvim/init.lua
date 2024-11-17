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
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
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
	{ "junegunn/fzf",    dir = "~/.fzf",      build = "./install --all" },
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
	{ "tpope/vim-fugitive" },
	-- Lsp
	{ "williamboman/mason.nvim" },
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x'
	},
	{ 'neovim/nvim-lspconfig' },
	{ 'onsails/lspkind.nvim' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp-signature-help' },
	{ 'saadparwaiz1/cmp_luasnip' },
	-- Copilot
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			-- add any opts here
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	-- Rust
	{
		'mrcjkb/rustaceanvim',
		version = '^5', -- Recommended
		lazy = false,
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
--- vim.cmd.colorscheme('nord')
vim.cmd.colorscheme "catppuccin"
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
local lspkind = require('lspkind')

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
		["<Tab>"] =
			cmp.mapping(function(fallback)
					if cmp.visible()
					then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip
							.expand_or_jump()
					elseif cmp_has_words_before()
					then
						cmp.complete()
					else
						fallback()
					end
				end,
				{ "i", "s" }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources(
		{ name = "copilot", group_index = 2 },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer', keyword_length = 3 },
		{ name = 'path' }
	),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			menu = ({
				buffer = "[BUF]",
				nvim_lsp = "[LSP]",
				luasnip = "[SNIP]",
				nvim_lua = "[LUA]",
				path = "[PATH]",
				nvim_lsp_signature_help = "[SIG]",
			})
		}),
	}
})
-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- #### LSP ###

-- install lsp automatically via mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "ruff", "clangd" }
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

-- c cpp
require('lspconfig').clangd.setup({
	filetypes = { "c", "cuda", "cpp", "lua" },
})

-- lua
require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())

-- rust
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
	"n",
	"<leader>a",
	function()
		vim.cmd.RustLsp('codeAction')
	end,
	{ silent = true, buffer = bufnr }
)

-- python
local on_attach_ruff = function(client, bufnr)
	client.server_capabilities.hoverProvider = false
end
require('lspconfig').pyright.setup({ cappacities = capabilities })
