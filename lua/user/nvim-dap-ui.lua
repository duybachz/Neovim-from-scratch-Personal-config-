local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
  return
end

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
