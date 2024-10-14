return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function ()
      vim.notify = require("notify")
      local status_ok, notify = pcall(require, "notify")
      if not status_ok then
        return
      end

      notify.setup({
        render = "default",
        timeout = 2500,
      })
    end
  }
}
