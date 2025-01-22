return {
  -- Colorschemes & Aesthetics
  {
    "folke/tokyonight.nvim",
    lazy = false,
  },
  {
    "lunarvim/colorschemes", -- A bunch of colorschemes you can try out
    lazy = false,
  },
  {
    "lunarvim/darkplus.nvim", -- Colorscheme
    lazy = false,
  },
  {
    "rebelot/kanagawa.nvim", -- Colorscheme
    lazy = false,
    opts = {
      transparent = true,
    },
    config = function ()
      local status, kanagawa = pcall(require, "kanagawa")
      if not status then
        return
      end

      kanagawa.setup({
        transparent = true,
        terminalColors = true,
      })

      local colorscheme = "kanagawa-dragon"

      -- Settting local variable status_ok; do protected call with vim.cmd
      -- .. for concatenate
      -- If you don't need the return value; use underscore
      local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
      if not status_ok then
        return
      end
      vim.cmd 'highlight TelescopeBorder guibg=none'
      vim.cmd 'highlight TelescopeTitle guibg=none'
    end
  },
}
