return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('trouble').setup {
      position = 'bottom',
      height = 10,
      width = 50,
      icons = true,
      mode = 'workspace_diagnostics',
      action_keys = {
        close = 'q',
        cancel = '<Esc>',
        refresh = 'r',
        jump = '<CR>',
        open_split = { '<c-x>' },
        open_vsplit = { '<c-v>' },
        open_tab = { '<c-t>' },
        jump_close = { 'o' },
        toggle_mode = 'm',
        toggle_preview = 'P',
        hover = 'h',
        preview = 'p',
        collapse = 'zc',
        expand = 'zo',
      },
    }
  end,
}
