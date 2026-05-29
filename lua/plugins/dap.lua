return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('dap-go').setup {
      dap_configurations = {
        {
          type = 'go',
          name = 'Debug (current file)',
          request = 'launch',
          program = '${file}',
        },
        {
          type = 'go',
          name = 'Debug (main package)',
          request = 'launch',
          program = '${workspaceFolder}',
        },
      },
    }

    dapui.setup {
      layouts = {
        {
          elements = {
            { id = 'scopes',      size = 0.40 },
            { id = 'breakpoints', size = 0.20 },
            { id = 'stacks',      size = 0.25 },
            { id = 'watches',     size = 0.15 },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            { id = 'repl',    size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          position = 'bottom',
          size = 10,
        },
      },
    }

    -- Auto open/close dap-ui with debug sessions
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Debug session keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<F5>', dap.continue, vim.tbl_extend('force', opts, { desc = 'DAP: continue' }))
    vim.keymap.set('n', '<F10>', dap.step_over, vim.tbl_extend('force', opts, { desc = 'DAP: step over' }))
    vim.keymap.set('n', '<F11>', dap.step_into, vim.tbl_extend('force', opts, { desc = 'DAP: step into' }))
    vim.keymap.set('n', '<F12>', dap.step_out, vim.tbl_extend('force', opts, { desc = 'DAP: step out' }))
    vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, vim.tbl_extend('force', opts, { desc = 'DAP: toggle breakpoint' }))
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, vim.tbl_extend('force', opts, { desc = 'DAP: conditional breakpoint' }))
    vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, vim.tbl_extend('force', opts, { desc = 'DAP: run to cursor' }))
    vim.keymap.set('n', '<leader>dt', dap.terminate, vim.tbl_extend('force', opts, { desc = 'DAP: terminate' }))
    vim.keymap.set('n', '<leader>du', dapui.toggle, vim.tbl_extend('force', opts, { desc = 'DAP: toggle UI' }))
    vim.keymap.set('n', '<leader>de', function()
      dapui.eval(nil, { enter = true })
    end, vim.tbl_extend('force', opts, { desc = 'DAP: eval expression' }))
  end,
}
