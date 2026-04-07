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
      swap_fields = false,
      swap_icons = false,
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
      ignore_focus = true,
      text = 'Taking a break',
      tooltip = '💤',
    },
    text = {
      viewing = function(opts) return 'Viewing: ' .. opts.filename end,
      editing = function(opts) return 'Editing: ' .. opts.filename end,
      file_browser = function(opts) return 'Browsing files in ' .. opts.name end,
      plugin_manager = function(opts) return 'Managing plugins in ' .. opts.name end,
      lsp = function(opts) return 'Configuring LSP in ' .. opts.name end,
      vcs = function(opts) return 'Committing changes in ' .. opts.name end,
      workspace = function(opts) return 'In: ' .. (opts.workspace or opts.workspace_dir or 'unknown') end,
    },
    buttons = nil,
  },
}
