return {
  {
    "lukas-reineke/indent-blankline.nvim", --Indent guides for Neovim
    event = "VeryLazy",
    config = function ()
      local status_ok, ibl = pcall(require, "ibl")
      if not status_ok then
        return
      end

      ibl.setup({
        indent = { char = "│"},
        exclude = {
          filetypes = { 'help', 'packer','nvimtree', 'dashboard', 'neo-tree' },
          buftypes = { 'terminal', 'nofile', 'quickfix' },
        }
      })
    end
  }
}
