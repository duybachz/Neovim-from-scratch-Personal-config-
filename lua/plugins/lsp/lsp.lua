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
    event = "VeryLazy",
    dependencies = {
      -- Auto-install LSPs, linters, formatters, debuggers (For Java)
      "WhoIsSethDaniel/mason-tool-installer.nvim",
       -- closes some gaps that exist between mason.nvim and null-ls
      "jay-babu/mason-null-ls.nvim",
       -- simple to use language server installer
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function ()
      local servers = {
        -- Java
        -- "jdtls",
        "gradle_ls",
        "groovyls",
        -- Lua
        "lua_ls",
        -- CSS
        "cssls",
        -- HTML
        "html",
        -- Javascript
        "ts_ls",
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
        registries = {
          'github:nvim-java/mason-registry',
          'github:mason-org/mason-registry',
        },
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

      -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
      -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
      vim.api.nvim_command('MasonToolsInstall')

      -- For Java debugging
      local mason_tool_status, mason_tool_installer = pcall(require, "mason-tool-installer")
      if not mason_tool_status then
        return
      end

      mason_tool_installer.setup({
        -- Install these linters, formatters and debuggers automatically
        ensure_installed = {
          "java-debug-adapter",
          "java-test"
        }
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

        if server ~= 'jdtls' then
          local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
          if require_ok then
            opts = vim.tbl_deep_extend("force", conf_opts, opts)
          end

          lspconfig[server].setup(opts)
        end
      end
    end
  },
}
