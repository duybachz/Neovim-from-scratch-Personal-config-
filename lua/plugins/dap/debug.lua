local function get_codelldb()
  local mason_registry = require "mason-registry"
  local codelldb = mason_registry.get_package "codelldb"
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  return codelldb_path, liblldb_path
end

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',
      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',
      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
    },
    opts = {
    },
    config = function ()
      local status_ok, dap = pcall(require, "dap")
      if not status_ok then
        return
      end

      local status_ok, dapui = pcall(require, "dapui")
      if not status_ok then
        return
      end
      
      require('mason-nvim-dap').setup({
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {
          function (config)
            -- all sources with no handler get passed here
            -- Keep original functionality
            require("mason-nvim-dap").default_setup(config)
          end,
        },

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
          'debugpy',
          'js-debug-adapter',
          'codelldb',
          'bash-debug-adapter',
          'java-debug-adapter',
        },
      })

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Configure debugging for languages
      -- For C, C++ and Rust
      local codelldb_path, _ = get_codelldb()
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          command = codelldb_path,
          args = {"--port", "${port}"},

          -- On windows you may have to uncomment this:
          -- detached = false,
        }
      }
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- For Typescript & Javascript
      -- Based on alphi2phi/neovim-pde
      vscode_js_debug = function()
        local function get_js_debug()
          local install_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
          return install_path .. "/js-debug/src/dapDebugServer.js"
        end

        for _, adapter in ipairs { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" } do
          require("dap").adapters[adapter] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              args = {
                get_js_debug(),
                "${port}",
              },
            },
          }
        end

        for _, language in ipairs { "typescript", "javascript" } do
          require("dap").configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Jest Tests",
              -- trace = true, -- include debugger info
              runtimeExecutable = "node",
              runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
              },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
            {
              type = "pwa-chrome",
              name = "Attach - Remote Debugging",
              request = "attach",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = "inspector",
              port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
              webRoot = "${workspaceFolder}",
            },
            {
              type = "pwa-chrome",
              name = "Launch Chrome",
              request = "launch",
              url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
              webRoot = "${workspaceFolder}",
              userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
            },
          }
        end

        for _, language in ipairs { "typescriptreact", "javascriptreact" } do
          require("dap").configurations[language] = {
            {
              type = "pwa-chrome",
              name = "Attach - Remote Debugging",
              request = "attach",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = "inspector",
              port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
              webRoot = "${workspaceFolder}",
            },
            {
              type = "pwa-chrome",
              name = "Launch Chrome",
              request = "launch",
              url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
              webRoot = "${workspaceFolder}",
              userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
            },
          }
        end
      end

      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }
      end
  }
}
