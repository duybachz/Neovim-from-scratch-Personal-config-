local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
 -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use "akinsho/bufferline.nvim" -- Bufferline plugin
  use "moll/vim-bbye" -- Plugin for closing current open buffer
  use "tpope/vim-surround" -- Plugin for automatically closing parenthesises
  use 'kyazdani42/nvim-web-devicons'
  use { "kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" }
  use { "nvim-lualine/lualine.nvim", commit = "a52f078026b27694d2290e34efa61a6e4a690621" }
  use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
  -- Lazyloading: Plugin is not in start directory
  -- Plugin will only starts if you run one of the following commands in the cmd parameter
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  -- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
  use "lukas-reineke/indent-blankline.nvim"

  -- Colorschemes & Aesthetics
  use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"
  use "rebelot/kanagawa.nvim"
  use "lukas-reineke/virt-column.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua" --Complete neovim's Lua runtime API such vim.lsp.*

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP & DAP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "jay-babu/mason-null-ls.nvim" -- closes some gaps that exist between mason.nvim and null-ls
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
  use "mfussenegger/nvim-dap" -- Debug Adapter Protocol client implementation for Neovim
  use {"jay-babu/mason-nvim-dap.nvim", requires = {"williamboman/mason.nvim", "mfussenegger/nvim-dap"} }
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
  use "nvimtools/none-ls.nvim" -- for formatters and linters
  use "nvimtools/none-ls-extras.nvim" -- Extra sources for nvimtools/none-ls.nvim

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use 'nvim-telescope/telescope-media-files.nvim'

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }

  -- Git
  use "lewis6991/gitsigns.nvim"
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use "hiphish/rainbow-delimiters.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()

  end

end)
