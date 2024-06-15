return {
  -- Essential plugins
  {
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
    commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7",
    lazy = false,
  },
  {
    "moll/vim-bbye", -- Plugin for closing current open buffer
    event = "VeryLazy",
  },
  {
    "tpope/vim-surround", -- Plugin for automatically closing parenthesises
    event = "VeryLazy"
  },
  -- Lazyloading: Plugin is not in start directory
  -- Plugin will only starts if you run one of the following commands in the cmd parameter
  {
    'tpope/vim-dispatch',
    cmd = {
      'Dispatch',
      'Make',
      'Focus',
      'Start'
    }
  },
  -- Plugins can have post-install/update hooks
  {
    'iamcco/markdown-preview.nvim',
    event = "VeryLazy",
    build = 'cd app && yarn install'
  },
}
