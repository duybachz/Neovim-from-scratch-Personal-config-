if vim.g.vscode then
  -- VSCode extension
  require "user.plugins"
  require "user.keymaps_vscode"
  vim.cmd[[source $HOME/.config/nvim/vscode/settings.vim]]
else
  -- Neovim
  require "user.options"
  require "user.keymaps"
  require "user.plugins"
end
