return {
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>", desc = "Open nvim-tree panel" },
      { "<leader>f",
        "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = true }))<cr>",
        desc = "Open telescope dropdown"
      },
      { "<c-t>", "<cmd>Telescope live_grep<cr>", desc = "Open live-grep" },
    },
    commit = "7282f7de8aedf861fe0162a559fc2b214383c51c",
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function ()
      local status_ok, nvim_tree = pcall(require, "nvim-tree")
      if not status_ok then
        return
      end

      local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
      if not config_status_ok then
        return
      end

      local tree_cb = nvim_tree_config.nvim_tree_callback

      nvim_tree.setup {
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        filters = {
          dotfiles = true,
        },
        renderer = {
          root_folder_modifier = ":t",
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "",
                staged = "S",
                unmerged = "",
                renamed = "➜",
                untracked = "U",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        view = {
          width = 30,
          side = "left",
          mappings = {
            list = {
              { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
              { key = "h", cb = tree_cb "close_node" },
              { key = "v", cb = tree_cb "vsplit" },
            },
          },
        },
      }
    end
  }
}
