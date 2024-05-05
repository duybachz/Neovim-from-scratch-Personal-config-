local colorscheme = "kanagawa-dragon"

-- Settting local variable status_ok; do protected call with vim.cmd
-- .. for concatenate
-- If you don't need the return value; use underscore
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
