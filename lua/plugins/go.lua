return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup {
      lsp_inlay_hints = { enable = false }, -- avoid conflict with existing gopls setup
      lsp_keymaps = false,                  -- keymaps are managed in lsp.lua
      lsp_diag_hdlr = false,
      dap_debug = true,
    }
    -- Format on save for Go files via go.nvim
    local fmt_group = vim.api.nvim_create_augroup('GoFormat', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = fmt_group,
      pattern = '*.go',
      callback = function()
        require('go.format').goimports()
      end,
    })
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod', 'gowork', 'gotmpl' },
  build = ':lua require("go.install").update_all_sync()',
}
