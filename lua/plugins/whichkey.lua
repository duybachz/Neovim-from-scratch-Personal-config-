return {
  {
    "folke/which-key.nvim",
    event="VeryLazy",
    config = function ()
      local status_ok, which_key = pcall(require, "which-key")
      if not status_ok then
        return
      end

      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 0

      local setup = {
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = false, -- bindings for prefixed with g
          },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        -- operators = { gc = "Comments" },
        icons = {
          rules = false,
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "➜", -- symbol used between a key and it's label
          group = "+", -- symbol prepended to a group
        },
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = {"<leader>"}, -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
      }

      local mappings = {
        -- Essentail mappings
        {
          "<leader>a",
          "<cmd>Alpha<cr>",
          desc = "Alpha",
          nowait = true,
          remap = false,
        },
        {
          "<leader>c",
          "<cmd>Bdelete!<CR>",
          desc = "Close Buffer",
          nowait = true,
          remap = false
        },
        {
          "<leader>e",
          desc = "Explorer",
          nowait = true,
          remap = false
        },
        {
          "<leader>f",
          "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
          desc = "Find files",
          nowait = true,
          remap = false
        },
        {
          "<leader>F",
          "<cmd>Telescope live_grep theme=ivy<cr>",
          desc = "Find Text",
          nowait = true,
          remap = false
        },
        {
          "<leader>h",
          "<cmd>nohlsearch<CR>",
          desc = "No Highlight",
          nowait = true,
          remap = false
        },
        {
          "<leader>k",
          "<cmd>BufferLinePick<CR>",
          desc = "Pick Bufferline",
          nowait = true,
          remap = false
        },
        {
          "<leader>P",
          "<cmd>lua require('telescope').extensions.projects.projects()<cr>",
          desc = "Projects",
          nowait = true,
          remap = false
        },
        {
          "<leader>w",
          "<cmd>w!<CR>",
          desc = "Save",
          nowait = true,
          remap = false
        },
        -- DAP
        {
          "<leader>d",
          group = "DAP",
          nowait = true,
          remap = false
        },
        -- Gitsigns
        {
          "<leader>g",
          group = "Git",
          nowait = true,
          remap = false
        },
        {
          "<leader>gR",
          "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
          desc = "Reset Buffer",
          nowait = true,
          remap = false
        },
        {
          "<leader>gb",
          "<cmd>Telescope git_branches<cr>",
          desc = "Checkout branch",
          nowait = true,
          remap = false
        },
        {
          "<leader>gc",
          "<cmd>Telescope git_commits<cr>",
          desc = "Checkout commit",
          nowait = true,
          remap = false
        },
        {
          "<leader>gd",
          "<cmd>Gitsigns diffthis HEAD<cr>",
          desc = "Diff",
          nowait = true,
          remap = false
        },
        {
          "<leader>gg",
          "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
          desc = "Lazygit",
          nowait = true,
          remap = false
        },
        {
          "<leader>gj",
          "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
          desc = "Next Hunk",
          nowait = true,
          remap = false
        },
        {
          "<leader>gk",
          "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
          desc = "Prev Hunk",
          nowait = true,
          remap = false
        },
        {
          "<leader>gl",
          "<cmd>lua require 'gitsigns'.blame_line()<cr>",
          desc = "Blame",
          nowait = true,
          remap = false
        },
        {
          "<leader>go",
          "<cmd>Telescope git_status<cr>",
          desc = "Open changed file",
          nowait = true,
          remap = false
        },
        {
          "<leader>gp",
          "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
          desc = "Preview Hunk",
          nowait = true,
          remap = false
        },
        {
          "<leader>gr",
          "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
          desc = "Reset Hunk",
          nowait = true,
          remap = false
        },
        {
          "<leader>gs",
          "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
          desc = "Stage Hunk",
          nowait = true,
          remap = false
        },
        {
          "<leader>gu",
          "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
          desc = "Undo Stage Hunk",
          nowait = true,
          remap = false
        },
        -- LSP & Telescope
        {
          "<leader>l",
          group = "LSP",
          nowait = true,
          remap = false
        },
        {
          "<leader>lI",
          "<cmd>LspInstallInfo<cr>",
          desc = "Installer Info",
          nowait = true,
          remap = false
        },
        {
          "<leader>lS",
          "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
          desc = "Workspace Symbols",
          nowait = true,
          remap = false
        },
        {
          "<leader>la",
          "<cmd>lua vim.lsp.buf.code_action()<cr>",
          desc = "Code Action",
          nowait = true,
          remap = false
        },
        {
          "<leader>ld",
          "<cmd>Telescope diagnostics bufnr=0<cr>",
          desc = "Document Diagnostics",
          nowait = true,
          remap = false
        },
        {
          "<leader>lf",
          "<cmd>lua vim.lsp.buf.format{async=true}<cr>",
          desc = "Format",
          nowait = true,
          remap = false
        },
        {
          "<leader>li",
          "<cmd>LspInfo<cr>",
          desc = "Info",
          nowait = true,
          remap = false
        },
        {
          "<leader>lj",
          "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
          desc = "Next Diagnostic",
          nowait = true,
          remap = false
        },
        {
          "<leader>lk",
          "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
          desc = "Prev Diagnostic",
          nowait = true,
          remap = false
        },
        {
          "<leader>ll",
          "<cmd>lua vim.lsp.codelens.run()<cr>",
          desc = "CodeLens Action",
          nowait = true,
          remap = false
        },
        {
          "<leader>lq",
          "<cmd>lua vim.diagnostic.setloclist()<cr>",
          desc = "Quickfix",
          nowait = true,
          remap = false
        },
        {
          "<leader>lr",
          "<cmd>lua vim.lsp.buf.rename()<cr>",
          desc = "Rename",
          nowait = true,
          remap = false
        },
        {
          "<leader>ls",
          "<cmd>Telescope lsp_document_symbols<cr>",
          desc = "Document Symbols",
          nowait = true,
          remap = false
        },
        {
          "<leader>lw",
          "<cmd>Telescope diagnostics<cr>",
          desc = "Workspace Diagnostics",
          nowait = true,
          remap = false
        },
        {
          "<leader>q",
          "<cmd>q!<CR>",
          desc = "Quit",
          nowait = true,
          remap = false
        },
        -- Search
        {
          "<leader>s",
          group = "Search",
          nowait = true,
          remap = false
        },
        {
          "<leader>sC",
          "<cmd>Telescope commands<cr>",
          desc = "Commands",
          nowait = true,
          remap = false
        },
        {
          "<leader>sM",
          "<cmd>Telescope man_pages<cr>",
          desc = "Man Pages",
          nowait = true,
          remap = false
        },
        {
          "<leader>sR",
          "<cmd>Telescope registers<cr>",
          desc = "Registers",
          nowait = true,
          remap = false
        },
        {
          "<leader>sb",
          "<cmd>Telescope git_branches<cr>",
          desc = "Checkout branch",
          nowait = true,
          remap = false
        },
        {
          "<leader>sc",
          "<cmd>Telescope colorscheme<cr>",
          desc = "Colorscheme",
          nowait = true,
          remap = false
        },
        {
          "<leader>sh",
          "<cmd>Telescope help_tags<cr>",
          desc = "Find Help",
          nowait = true,
          remap = false
        },
        {
          "<leader>sk",
          "<cmd>Telescope keymaps<cr>",
          desc = "Keymaps",
          nowait = true,
          remap = false
        },
        {
          "<leader>sr",
          "<cmd>Telescope oldfiles<cr>",
          desc = "Open Recent File",
          nowait = true,
          remap = false
        },
        -- Terminal
        {
          "<leader>t",
          group = "Terminal",
          nowait = true,
          remap = false
        },
        {
          "<leader>tf",
          "<cmd>ToggleTerm direction=float<cr>",
          desc = "Float",
          nowait = true,
          remap = false
        },
        {
          "<leader>th",
          "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
          desc = "Horizontal",
          nowait = true,
          remap = false
        },
        {
          "<leader>tn",
          "<cmd>lua _NODE_TOGGLE()<cr>",
          desc = "Node",
          nowait = true,
          remap = false
        },
        {
          "<leader>tp",
          "<cmd>lua _PYTHON_TOGGLE()<cr>",
          desc = "Python",
          nowait = true,
          remap = false
        },
        {
          "<leader>tt",
          "<cmd>lua _HTOP_TOGGLE()<cr>",
          desc = "Htop",
          nowait = true,
          remap = false
        },
        {
          "<leader>tu",
          "<cmd>lua _NCDU_TOGGLE()<cr>",
          desc = "NCDU",
          nowait = true,
          remap = false
        },
        {
          "<leader>tv",
          "<cmd>ToggleTerm size=80 direction=vertical<cr>",
          desc = "Vertical",
          nowait = true,
          remap = false
        },
        {
          "<leader>x",
          group = "Trouble",
          nowait = true,
          remap = false
        },
        {
          "<leader>j",
          group = "JDTLS",
          nowait = true,
          remap = false
        },
        {
          "<leader>n",
          group = "Neotest",
          nowait = true,
          remap = false
        },
        {
          "<leader>nl",
          "<cmd>Neotest summary<cr>",
          desc = "Summary",
          nowait = true,
          remap = false
        },
        {
          "<leader>nf",
          "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
          desc = "Run current file",
          nowait = true,
          remap = false
        },
        {
          "<leader>ns",
          "<cmd>lua require('neotest').run.run({suite = true})<cr>",
          desc = "Run test suite",
          nowait = true,
          remap = false
        },
        {
          "<leader>nm",
          "<cmd>lua require('neotest').run.run()<cr>",
          desc = "Run nearest method",
          nowait = true,
          remap = false
        },
      }

      which_key.setup(setup)
      which_key.add(mappings)
      -- which_key.register(mappings, opts)
    end
  }
}
