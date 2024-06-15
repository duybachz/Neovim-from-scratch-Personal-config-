return {
  {
    "neovim/nvim-lspconfig", -- enable LSP
    event = "VeryLazy",
    config = function ()
      local status_ok, _ = pcall(require, "lspconfig")
      if not status_ok then
        return
      end

      require("plugins.lsp.handlers.handlers").setup()
    end
  },
  {
    "williamboman/mason.nvim", -- simple to  language server installer
    dependencies = {
       -- closes some gaps that exist between mason.nvim and null-ls
      "jay-babu/mason-null-ls.nvim",
       -- simple to use language server installer
      "williamboman/mason-lspconfig.nvim",
    },
    event = "VeryLazy",
    config = function ()
      local servers = {
        -- Lua
        "lua_ls",
        -- CSS
        "cssls",
        -- HTML
        "html",
        -- Javascript
        "tsserver",
        -- Python
        "pyright",
        -- Bash
        "bashls",
        -- JSON
        "jsonls",
        -- C
        "clangd",
        -- YAML
        "yamlls",
        -- CMake
        "cmake",
      }

      local settings = {
        ui = {
          border = "none",
          icons = {
            package_installed = "◍",
            package_pending = "◍",
            package_uninstalled = "◍",
          },
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
      }

      require("mason").setup(settings)
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
      })

      local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_status_ok then
        return
      end

      local opts = {}

      --
      for _, server in pairs(servers) do
        opts = {
          on_attach = require("plugins.lsp.handlers.handlers").on_attach,
          capabilities = require("plugins.lsp.handlers.handlers").capabilities,
        }

        server = vim.split(server, "@")[1]

        local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
        if require_ok then
          opts = vim.tbl_deep_extend("force", conf_opts, opts)
        end

        lspconfig[server].setup(opts)
      end
    end
  },
}
