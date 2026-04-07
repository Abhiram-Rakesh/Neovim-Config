return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  event = 'VimEnter',
  opts = {
    editor = {
      client = 'neovim',
      tooltip = 'Neovim',
    },
    display = {
      show_time = true,
      show_repository = true,
      show_cursor_position = false,
      swap_fields = false,
      swap_icons = false,
      workspace_blacklist = {},
    },
    lsp = {
      show_problem_count = false,
      severity = 1,
      scope = 'workspace',
    },
    idle = {
      enabled = true,
      show_status = true,
      timeout = 300000, -- 5 minutes
      disable_on_focus = true,
      text = 'Taking a break',
      tooltip = '💤',
    },
    text = {
      viewing = 'Viewing {}',
      editing = 'Editing {}',
      file_browser = 'Browsing files in {}',
      plugin_manager = 'Managing plugins in {}',
      lsp_manager = 'Configuring LSP in {}',
      vcs = 'Committing changes in {}',
      workspace = 'In {}',
    },
    buttons = nil,
  },
}
