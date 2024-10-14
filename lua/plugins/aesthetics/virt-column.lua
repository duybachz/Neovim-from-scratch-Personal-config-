return {
  {
    "lukas-reineke/virt-column.nvim", -- Display a character as the colorcolumn
    event = "VeryLazy",
    config = function ()
      local status_ok, virt_column = pcall(require, "virt-column")
      if not status_ok then
        return
      end

      virt_column.setup({
        char = "▏",
        virtcolumn = "+1, 120",
      })
    end
  },
}
