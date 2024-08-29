-- debug adapter protocol - to run debuggers in neovim
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup()

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

    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step Over' })
    vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step Out' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
  end,
}
