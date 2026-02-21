return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('harpoon').setup {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      global_settings = {
        save_on_toggle = true,
        mark_branch = true,
      },
    }
  end,
}
