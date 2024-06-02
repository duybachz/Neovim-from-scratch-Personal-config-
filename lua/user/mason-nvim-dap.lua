local status_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if not status_ok then
  return
end

mason_nvim_dap.setup({
  ensure_installed = {
    'codelldb',
  },
  handlers = {},
})
