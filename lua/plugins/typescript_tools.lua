return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = function ()
      local opts = {
        on_attach = require("plugins.lsp.handlers.handlers").on_attach,
        capabilities = require("plugins.lsp.handlers.handlers").capabilities,
      }
      return opts
    end,
    ft = {'typescript', 'javascript', 'typescriptreact'},
  },
}
