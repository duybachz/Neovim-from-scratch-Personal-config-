if vim.g.vscode then
  -- VSCode extension
  require "user.plugins"
  require "user.keymaps_vscode"
  require "user.options"
  vim.cmd[[source $HOME/.config/nvim/vscode/settings.vim]]

  -- Options
  -- vim.opt.clipboard = "unnamedplus"
else
  -- Neovim
  require "user.options"
  require "user.keymaps"
  -- require "user.plugins"
end
