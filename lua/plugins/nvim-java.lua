return {
  {
    'nvim-java/nvim-java',
    ft = {"java"},
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
    },
    config = function ()
      local ok_status, java = pcall(require, "java")
      if not ok_status then
        print("Java not available")
      end

      java.setup({})

      local ok_status_2, lspconfig = pcall(require, 'lspconfig')
      if not ok_status_2 then
        print("lspconfig not available")
      end

      lspconfig.jdtls.setup({
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "OpenJDK-17",
                  path = "/Users/bachvu7723/.sdkman/candidates/java/17-open",
                  default = true
                }
              }
            }
          }
        },
        on_attach = require("plugins.lsp.handlers.handlers").on_attach,
        capabilities = require("plugins.lsp.handlers.handlers").capabilities,
      })
    end
  }
}
