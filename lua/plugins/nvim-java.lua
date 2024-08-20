return {
  {
    'nvim-java/nvim-java',
    ft = {"java"},
    config = function ()
      local ok_status, java = pcall(require, "java")
      if not ok_status then
        return
      end

      local ok_status_2, lspconfig = pcall(require, "lspconfig")
      if not ok_status_2 then
        return
      end

      lspconfig.jdtls.setup({})
    end
  }
}
