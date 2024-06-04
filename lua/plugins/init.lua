return {
 -- My plugins here
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
  "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
  "numToStr/Comment.nvim", -- Easily comment stuff
  "akinsho/bufferline.nvim", -- Bufferline plugin
  "moll/vim-bbye", -- Plugin for closing current open buffer
  "tpope/vim-surround", -- Plugin for automatically closing parenthesises
  'kyazdani42/nvim-web-devicons',
  { "kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" },
  { "nvim-lualine/lualine.nvim", commit = "a52f078026b27694d2290e34efa61a6e4a690621" },
  { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" },
  -- Lazyloading: Plugin is not in start directory
  -- Plugin will only starts if you run one of the following commands in the cmd parameter
  {'tpope/vim-dispatch', lazy = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}},
  -- Plugins can have post-install/update hooks
  {'iamcco/markdown-preview.nvim', build = 'cd app && yarn install'},
  "lukas-reineke/indent-blankline.nvim",
  "RRethy/vim-illuminate",

  -- Colorschemes & Aesthetics
  "lunarvim/colorschemes", -- A bunch of colorschemes you can try out
  "lunarvim/darkplus.nvim",
  "rebelot/kanagawa.nvim",
  "lukas-reineke/virt-column.nvim",

  -- cmp plugins
  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua", --Complete neovim's Lua runtime API such vim.lsp.*

  -- snippets
  "L3MON4D3/LuaSnip", --snippet engine
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- LSP 
  "neovim/nvim-lspconfig", -- enable LSP
  "williamboman/mason.nvim", -- simple to  language server installer
  "jay-babu/mason-null-ls.nvim", -- closes some gaps that exist between mason.nvim and null-ls
  "williamboman/mason-lspconfig.nvim", -- simple to use language server installer

  -- null-ls alternative
  "nvimtools/none-ls.nvim", -- for formatters and linters
  "nvimtools/none-ls-extras.nvim", -- Extra sources for nvimtools/none-ls.nvim

  -- Telescope
  "nvim-telescope/telescope.nvim",
  'nvim-telescope/telescope-media-files.nvim',

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter" },

  -- Git
  "lewis6991/gitsigns.nvim",
  'JoosepAlviste/nvim-ts-context-commentstring',
  "hiphish/rainbow-delimiters.nvim",
}
