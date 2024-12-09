return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function ()
      local treesitter = require "nvim-treesitter"
      local configs = require "nvim-treesitter.configs"

      configs.setup {
        auto_install = true,
        ensure_installed = {
          "lua",
          "markdown",
          "markdown_inline",
          "bash",
          "python",
          "latex",
        }, -- put the language you want in this array
        -- ensure_installed = "all", -- one of "all" or a list of languages
        ignore_install = { "" },                                                       -- List of parsers to ignore installing
        sync_install = false,                                                          -- install languages synchronously (only applied to `ensure_installed`)

        highlight = {
          enable = true,       -- false will disable the whole extension
          disable = { "css" }, -- list of language that will be disabled
        },
        indent = {
          enable = true,
          disable = { "python", "css" }
        },

        --[[ context_commentstring = {
          enable = true,
          enable_autocmd = false,
        }, ]]
      }
    end
  }
}
