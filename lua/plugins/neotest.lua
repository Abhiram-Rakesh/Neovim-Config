return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-go',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-go' {
          experimental = {
            test_table = true,
          },
          args = { '-count=1', '-timeout=60s' },
        },
      },
      output = { open_on_run = true },
      summary = {
        animated = true,
      },
    }

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>tr', function()
      require('neotest').run.run()
    end, vim.tbl_extend('force', opts, { desc = 'Test: run nearest' }))

    vim.keymap.set('n', '<leader>tf', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, vim.tbl_extend('force', opts, { desc = 'Test: run file' }))

    vim.keymap.set('n', '<leader>ts', function()
      require('neotest').summary.toggle()
    end, vim.tbl_extend('force', opts, { desc = 'Test: toggle summary' }))

    vim.keymap.set('n', '<leader>to', function()
      require('neotest').output.open { enter = true }
    end, vim.tbl_extend('force', opts, { desc = 'Test: open output' }))

    vim.keymap.set('n', '<leader>tS', function()
      require('neotest').run.stop()
    end, vim.tbl_extend('force', opts, { desc = 'Test: stop' }))

    -- Run nearest test with DAP
    vim.keymap.set('n', '<leader>td', function()
      require('neotest').run.run { strategy = 'dap' }
    end, vim.tbl_extend('force', opts, { desc = 'Test: debug nearest' }))
  end,
}
