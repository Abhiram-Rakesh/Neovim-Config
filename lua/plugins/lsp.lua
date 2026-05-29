return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', config = true },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = { window = { winblend = 0 } },
      },
    },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- LspAttach mappings
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local opts = { buffer = event.buf, noremap = true, silent = true }
        local function nmap(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, vim.tbl_extend('force', opts, { desc = desc }))
        end
        nmap('gd', vim.lsp.buf.definition, 'LSP: goto definition')
        nmap('gr', vim.lsp.buf.references, 'LSP: references')
        nmap('<leader>rn', vim.lsp.buf.rename, 'LSP: rename')
        nmap('<leader>ca', vim.lsp.buf.code_action, 'LSP: code action')
      end,
    })

    -- Capabilities for nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if pcall(require, 'cmp_nvim_lsp') then
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    end

    -- Use vim.lsp.config for Neovim 0.11+
    -- ruff (Python linter)
    vim.lsp.config('ruff', {
      capabilities = capabilities,
    })

    -- pylsp (Python LSP)
    vim.lsp.config('pylsp', {
      capabilities = capabilities,
    })

    -- gopls (Go)
    vim.lsp.config('gopls', {
      capabilities = capabilities,
      settings = {
        gopls = {
          gofumpt = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            nilness = true,
            unusedwrite = true,
          },
          staticcheck = true,
        },
      },
    })

    -- terraformls (Terraform)
    vim.lsp.config('terraformls', {
      capabilities = capabilities,
    })

    -- yamlls (YAML)
    vim.lsp.config('yamlls', {
      capabilities = capabilities,
      settings = {
        yaml = {
          validate = true,
          schemaStore = {
            enable = true,
            url = 'https://www.schemastore.org/api/json/catalog.json',
          },
          customSchemas = {
            {
              uri = 'https://json.schemastore.org/github-workflow.json',
              fileMatch = { '.github/workflows/*.yml', '.github/workflows/*.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/gitlab-ci.json',
              fileMatch = { '.gitlab-ci.yml', '.gitlab-ci.yaml', 'ci/*.yml', 'ci/*.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/renovate.json',
              fileMatch = { 'renovate.json', 'renovate.json5' },
            },
            {
              uri = 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/deployment.json',
              fileMatch = { 'k8s/*.yml', 'k8s/*.yaml', '*.k8s.yml', '*.k8s.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/prometheus-rule.json',
              fileMatch = { '*.rules.yml', '*.rules.yaml', 'rules/*.yml', 'rules/*.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/alertmanager.json',
              fileMatch = { 'alertmanager.yml', 'alertmanager.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/grafana-dashboard.json',
              fileMatch = { 'dashboards/*.json', 'grafana-dashboard.json' },
            },
            {
              uri = 'https://json.schemastore.org/argocd.json',
              fileMatch = { 'argocd-*.yml', 'argocd-*.yaml', 'applicationset.yml', 'applicationset.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/argocd-application.json',
              fileMatch = { 'application.yml', 'application.yaml', 'app.yaml', '*.app.yml', '*.app.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/argo-workflows.json',
              fileMatch = { '*workflow*.yml', '*workflow*.yaml', 'workflows/*.yml', 'workflows/*.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/kustomization.json',
              fileMatch = { 'kustomization.yml', 'kustomization.yaml', 'kustomize/**' },
            },
            {
              uri = 'https://raw.githubusercontent.com/helmfile/helmfile/main/schema.json',
              fileMatch = { 'helmfile.yml', 'helmfile.yaml' },
            },
            {
              uri = 'https://raw.githubusercontent.com/aws/serverless-application-model/master/samschema/sam.schema.json',
              fileMatch = { 'sam.yml', 'sam.yaml', 'template.yml', 'template.yaml' },
            },
            {
              uri = 'https://json.schemastore.org/cloudformation.json',
              fileMatch = { '*.cfn.yml', '*.cfn.yaml', 'cloudformation/*.yml', 'cloudformation/*.yaml' },
            },
          },
        },
      },
    })

    -- jsonls (JSON)
    vim.lsp.config('jsonls', {
      capabilities = capabilities,
    })

    -- bashls (Bash)
    vim.lsp.config('bashls', {
      capabilities = capabilities,
    })

    -- ansiblels (Ansible)
    vim.lsp.config('ansiblels', {
      capabilities = capabilities,
    })

    -- helm_ls (Helm)
    vim.lsp.config('helm_ls', {
      capabilities = capabilities,
    })

    -- docker-language-server (Docker)
    vim.lsp.config('docker_language_server', {
      capabilities = capabilities,
    })

    -- lua_ls (Lua - for Neovim config)
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          format = { enable = false },
        },
      },
    })

    -- Ensure mason-tool-installer attempts installation
    local ensure_installed = { 'ruff', 'pylsp', 'gopls', 'docker_language_server', 'terraformls', 'yamlls', 'jsonls', 'bashls', 'ansiblels', 'helm_ls', 'lua_ls', 'stylua', 'hadolint' }
    if pcall(require, 'mason-tool-installer') then
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end
  end,
}
