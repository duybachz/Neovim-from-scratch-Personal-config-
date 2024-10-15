local function getCodeLLDB()
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
      -- Commented out due to mason being started in lsp
      -- 'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
    },
    keys = {
      "<leader>d"
    },
    config = function ()
      local status_ok, dap = pcall(require, "dap")
      if not status_ok then
        return
      end

      local status_ok_1, dapui = pcall(require, "dapui")
      if not status_ok_1 then
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
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<leader>dC', function ()
        if (vim.fn.filereadable(".vscode/launch.json")) then
          require('dap.ext.vscode').load_launchjs()
        end
        dap.continue()
      end, { desc = 'Debug: Start with config'})
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint Condition' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<leader>dO', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>dl', dap.repl.toggle, { desc = 'Debug: Toggle REPL' })
      vim.keymap.set('n', '<leader>dL', dap.run_last, { desc = 'Debug: Run last' })
      vim.keymap.set('n', '<leader>dp', dap.pause, { desc = 'Debug: Pause' })
      vim.keymap.set('n', '<leader>dR', dap.restart, { desc = 'Debug: Restart' })
      vim.keymap.set('n', '<leader>dT', dap.terminate, { desc = 'Debug: Terminate session' })
      vim.keymap.set('n', '<leader>dj', dap.down, { desc = 'Debug: Move down stack trace' })
      vim.keymap.set('n', '<leader>dk', dap.up, { desc = 'Debug: Move up stack trace' })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup({
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
          },
        },
      })

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Dap UI' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Configure debugging for languages
      -- For Python
      if (vim.bo.filetype == 'python') then
        local _, dapPython = pcall(require, "dap-python");
        if not _ then
          return
        end

        dapPython.setup()
      end
      -- For C, C++ and Rust
      local codelldb_path, _ = getCodeLLDB()
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
          arg = {}
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- For Typescript & Javascript
      -- Based on alphi2phi/modern-neovim 
      -- https://github.com/alpha2phi/modern-neovim/blob/main/lua/pde/typescript.lua
      local function get_js_debug()
        local install_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
        return install_path .. "/js-debug/src/dapDebugServer.js"
      end

      for _, adapter in ipairs { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" } do
        dap.adapters[adapter] = {
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
        dap.configurations[language] = {
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
        dap.configurations[language] = {
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

      -- For Go
      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }

      -- For Java
      dap.configurations.java = {
        {
          name = "Debug Launch (2GB)";
          type = 'java';
          request = 'launch';
          vmArgs = "" ..
            "-Xmx2g "
        },
        {
          name = "Debug Attach (8000)";
          type = 'java';
          request = 'attach';
          hostName = "127.0.0.1";
          port = 8000;
        },
        {
          name = "Debug Attach (5005)";
          type = 'java';
          request = 'attach';
          hostName = "127.0.0.1";
          port = 5005;
        },
        {
          name = "My Custom Java Run Configuration",
          type = "java",
          request = "launch",
          -- You need to extend the classPath to list your dependencies.
          -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
          -- classPaths = {},

          -- If using multi-module projects, remove otherwise.
          -- projectName = "yourProjectName",

          -- javaExec = "java",
          mainClass = "replace.with.your.fully.qualified.MainClass",

          -- If using the JDK9+ module system, this needs to be extended
          -- `nvim-jdtls` would automatically populate this property
          -- modulePaths = {},
          vmArgs = "" ..
            "-Xmx2g "
        },
      }
      end
  }
}
