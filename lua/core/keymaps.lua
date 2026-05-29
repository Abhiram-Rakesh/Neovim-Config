-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', 'ZS', '<cmd> w! <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
-- Add a Empty line
vim.keymap.set('n', '<leader>o', 'o<Esc>o', opts) -- adds a line below without entering insert mode
vim.keymap.set('n', '<leader>O', 'O<Esc>O', opts) -- adds a line above without entering insert mode

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- Telescope Keymaps
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', opts) -- fuzzy searches for files in your project/directory
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', opts) -- search text in files (needs ripgrep)
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', opts) -- list open buffers
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', opts) -- Search Neovim's documentation
-- Live Preview
vim.keymap.set('n', '<leader>lp', ':LivePreview start<CR>', opts) -- starts a live preview of the current buffer
vim.keymap.set('n', '<leader>lx', ':LivePreview stop<CR>', opts) -- stops a live preview of the current buffer
-- Code Surfing Keymaps
vim.keymap.set('n', '<leader>;', '$a;<Esc>', opts) -- jumps to the end of the line and adds a ";"
vim.keymap.set('n', '<leader>,', '$a,<Esc>', opts) -- jumps to the end of the line and adds a ","

-- ToggleTerm keymaps
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', opts) -- toggle terminal
vim.keymap.set('i', '<leader>tt', '<cmd>ToggleTerm<CR>', opts) -- toggle terminal in insert mode

-- Trouble keymaps
vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<CR>', opts) -- toggle trouble
vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<CR>', opts) -- workspace diagnostics
vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<CR>', opts) -- document diagnostics

-- Harpoon keymaps
vim.keymap.set('n', '<leader>ha', function() require('harpoon.mark').add_file() end, { desc = 'Harpoon: add file' })
vim.keymap.set('n', '<leader>hh', function() require('harpoon.ui').toggle_quick_menu() end, { desc = 'Harpoon: toggle menu' })
vim.keymap.set('n', '<leader>h1', function() require('harpoon.ui').nav_file(1) end, { desc = 'Harpoon: go to file 1' })
vim.keymap.set('n', '<leader>h2', function() require('harpoon.ui').nav_file(2) end, { desc = 'Harpoon: go to file 2' })
vim.keymap.set('n', '<leader>h3', function() require('harpoon.ui').nav_file(3) end, { desc = 'Harpoon: go to file 3' })
vim.keymap.set('n', '<leader>h4', function() require('harpoon.ui').nav_file(4) end, { desc = 'Harpoon: go to file 4' })

-- Cloud CLI commands
local function cloud_menu()
  local cmds = {
    { category = 'AWS', items = {
      { cmd = 'aws s3 ls s3://<bucket>/', desc = 'List S3 bucket' },
      { cmd = 'aws s3 cp <source> s3://<bucket>/<path>', desc = 'Copy to S3' },
      { cmd = 'aws ec2 describe-instances', desc = 'List EC2 instances' },
      { cmd = 'aws ecs list-clusters', desc = 'List ECS clusters' },
      { cmd = 'aws ecr get-login-password | docker login ...', desc = 'ECR Docker login' },
      { cmd = 'aws lambda invoke --function-name <fn> --payload ...', desc = 'Invoke Lambda' },
    }},
    { category = 'GCP', items = {
      { cmd = 'gsutil ls gs://<bucket>/', desc = 'List GCS bucket' },
      { cmd = 'gsutil cp <source> gs://<bucket>/<path>', desc = 'Copy to GCS' },
      { cmd = 'gcloud container clusters get-credentials <cluster>', desc = 'GKE credentials' },
      { cmd = 'gcloud compute instances list', desc = 'List GCE instances' },
      { cmd = 'gcloud run deploy <service> --image ...', desc = 'Deploy to Cloud Run' },
    }},
    { category = 'Azure', items = {
      { cmd = 'az storage blob list --container-name <c>', desc = 'List storage blobs' },
      { cmd = 'az storage blob upload --container-name ...', desc = 'Upload blob' },
      { cmd = 'az vm list --resource-group <rg>', desc = 'List VMs' },
      { cmd = 'az aks get-credentials --rg <rg> --name <cluster>', desc = 'AKS credentials' },
    }},
    { category = 'Kubernetes', items = {
      { cmd = 'kubectl get pods -n <namespace>', desc = 'Get pods' },
      { cmd = 'kubectl describe pod <pod> -n <ns>', desc = 'Describe pod' },
      { cmd = 'kubectl logs <pod> -n <namespace>', desc = 'Get pod logs' },
      { cmd = 'kubectl exec -it <pod> -n <ns> -- /bin/sh', desc = 'Exec into pod' },
      { cmd = 'kubectl apply -f <file.yaml>', desc = 'Apply manifest' },
      { cmd = 'kubectl config use-context <context>', desc = 'Switch context' },
    }},
    { category = 'Docker', items = {
      { cmd = 'docker build -t <image>:<tag> .', desc = 'Build image' },
      { cmd = 'docker run -d --name <name> <image>', desc = 'Run container' },
      { cmd = 'docker push <image>:<tag>', desc = 'Push image' },
      { cmd = 'docker-compose up -d', desc = 'Docker Compose up' },
    }},
    { category = 'Consul', items = {
      { cmd = 'consul kv get <key>', desc = 'Get Consul KV value' },
      { cmd = 'consul kv put <key> <value>', desc = 'Put Consul KV value' },
      { cmd = 'consul kv delete <key>', desc = 'Delete Consul KV key' },
      { cmd = 'consul members', desc = 'List Consul cluster members' },
      { cmd = 'consul catalog services', desc = 'List registered services' },
      { cmd = 'consul health service <service>', desc = 'Check service health' },
    }},
    { category = 'Vault', items = {
      { cmd = 'vault kv get <path>', desc = 'Get secret from Vault' },
      { cmd = 'vault kv put <path> <key>=<value>', desc = 'Put secret to Vault' },
      { cmd = 'vault kv delete <path>', desc = 'Delete secret from Vault' },
      { cmd = 'vault secrets list', desc = 'List enabled secrets engines' },
      { cmd = 'vault policy list', desc = 'List Vault policies' },
      { cmd = 'vault token lookup', desc = 'Lookup current token info' },
    }},
  }

  local lines = { 'Cloud CLI Commands (y to yank)' }
  for _, cat in ipairs(cmds) do
    table.insert(lines, '▼ ' .. cat.category)
    for _, item in ipairs(cat.items) do
      table.insert(lines, '  ' .. item.cmd .. '  (' .. item.desc .. ')')
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })

  local width = 80
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_set_option_value('cursorline', true, { win = win })

  vim.api.nvim_buf_create_user_command(buf, 'Quit', function()
    vim.api.nvim_win_close(win, true)
  end, {})

  vim.keymap.set('n', 'q', ':quit<CR>', { buffer = buf })
  vim.keymap.set('n', '<Esc>', ':quit<CR>', { buffer = buf })
end

vim.keymap.set('n', '<leader>cc', cloud_menu, { desc = 'Cloud CLI commands' })

-- Trivy security scanning
local function trivy_menu()
  local cmds = {
    { cmd = 'trivy fs .', desc = 'Scan filesystem for vulnerabilities' },
    { cmd = 'trivy fs . --severity HIGH,CRITICAL', desc = 'Scan filesystem (HIGH/CRITICAL only)' },
    { cmd = 'trivy image <image>', desc = 'Scan Docker image' },
    { cmd = 'trivy image <image> --severity HIGH,CRITICAL', desc = 'Scan image (HIGH/CRITICAL only)' },
    { cmd = 'trivy k8s cluster', desc = 'Scan Kubernetes cluster' },
    { cmd = 'trivy k8s --context <context> deploy <namespace>', desc = 'Scan K8s deployment' },
    { cmd = 'trivy config .', desc = 'Scan IaC configuration files' },
    { cmd = 'trivy repo .', desc = 'Scan repository secrets' },
    { cmd = 'trivy sbom .', desc = 'Generate SBOM' },
    { cmd = 'trivy db update', desc = 'Update vulnerability database' },
  }

  local lines = { 'Trivy Commands (Enter to run, Esc to close)' }
  for _, item in ipairs(cmds) do
    table.insert(lines, item.cmd .. '  (' .. item.desc .. ')')
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })

  local width = 70
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_set_option_value('cursorline', true, { win = win })

  vim.keymap.set('n', '<CR>', function()
    local cursor = vim.api.nvim_win_get_cursor(win)[1]
    if cursor > 1 and cursor <= #cmds + 1 then
      local cmd = cmds[cursor - 1].cmd
      vim.api.nvim_win_close(win, true)
      vim.cmd('ToggleTerm direction=float name=Trivy')
      vim.defer_fn(function()
        vim.cmd('term trivy ' .. cmd:sub(7))
      end, 100)
    end
  end, { buffer = buf })

  vim.keymap.set('n', 'q', ':quit<CR>', { buffer = buf })
  vim.keymap.set('n', '<Esc>', ':quit<CR>', { buffer = buf })
end

vim.keymap.set('n', '<leader>tv', trivy_menu, { desc = 'Trivy security scanner' })
