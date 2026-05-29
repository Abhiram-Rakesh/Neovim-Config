return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    -- mason-null-ls setup (ensure installed)
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier',
        'eslint_d',
        'shfmt',
        'checkmake',
        'golangci-lint',
        'goimports',
        'hadolint',
        'cfn-lint',
        -- "stylua", "ruff" etc if you need them
      },
      automatic_installation = true,
    }

    -- Ensure common React filetypes are covered
    local prettier_filetypes = {
      'html',
      'json',
      'yaml',
      'markdown',
      'javascript',
      'javascriptreact', -- <--- important for .jsx
      'typescript',
      'typescriptreact', -- <--- for .tsx
      'css',
      'scss',
      'less',
    }

    local sources = {
      diagnostics.checkmake,
      diagnostics.golangci_lint.with {
        condition = function(utils)
          return utils.root_has_file { 'go.mod' }
        end,
      },
      diagnostics.hadolint,
      diagnostics.cfn_lint,
      -- Prettier for many web filetypes (including react .jsx/.tsx)
      formatting.prettier.with {
        filetypes = prettier_filetypes,
        -- optional: pass extra args to prettier if required
        -- extra_args = { "--single-quote", "--print-width", "100" },
      },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      formatting.goimports,
      -- ruff / ruff_format if you use Python
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
      -- optionally add eslint_d code actions (useful for `:lua vim.lsp.buf.code_action()` or auto-fix)
      -- code_actions.eslint_d,
      -- diagnostics.eslint_d,
    }

    -- Optional: ensure Neovim recognizes .jsx as javascriptreact (usually not needed)
    vim.filetype.add {
      extension = {
        jsx = 'javascriptreact',
        tsx = 'typescriptreact',
      },
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    null_ls.setup {
      sources = sources,
      on_attach = function(client, bufnr)
        -- only enable the autoformat on save if the LSP client supports it
        if client.supports_method 'textDocument/formatting' then
          -- clear previous autocmds in this group for this buffer
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }

          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              -- Use filter to prefer null-ls for formatting (avoids conflicts with other formatters)
              vim.lsp.buf.format {
                bufnr = bufnr,
                async = false,
                filter = function(format_client)
                  -- if you want to prefer null-ls only:
                  return format_client.name == 'null-ls'
                  -- if you want to allow any client:
                  -- return true
                end,
              }
              -- If you prefer eslint_d to fix after prettier, you can call eslint_d fix as a code action here
              -- or run eslint_d from an external command.
            end,
          })
        end
      end,
    }
  end,
}
