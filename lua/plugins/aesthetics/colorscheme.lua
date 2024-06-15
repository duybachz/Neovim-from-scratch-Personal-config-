return {
  -- Colorschemes & Aesthetics
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
    config = function ()
      local colorscheme = "kanagawa-dragon"

      -- Settting local variable status_ok; do protected call with vim.cmd
      -- .. for concatenate
      -- If you don't need the return value; use underscore
      local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
      if not status_ok then
        return
      end
    end
  },
}
