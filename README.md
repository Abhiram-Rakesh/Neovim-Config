# Neovim Config — DevOps Edition

A production-ready Neovim configuration built for DevOps engineers. Focused on Infrastructure as Code, containers, Kubernetes, cloud platforms, and CI/CD — not web development. Built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

![Neovim](https://img.shields.io/badge/Neovim-0.11+-57A143?style=flat&logo=neovim)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

---

## Quick Install

```bash
# One-command install
curl -sL https://raw.githubusercontent.com/Abhiram-Rakesh/Neovim-Config/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/Abhiram-Rakesh/Neovim-Config.git ~/.config/nvim
nvim
```

Lazy.nvim bootstraps itself on first launch and installs all plugins automatically. Mason installs all LSP servers, formatters, and linters.

---

## Prerequisites

| Dependency | Purpose |
|---|---|
| **Neovim 0.11+** | Required |
| **Git** | Plugin manager, gitsigns |
| **Ripgrep** | Telescope live grep |
| **Node.js** | Some LSP servers |
| **Go** | gopls, go tools |
| **Python 3** | pylsp, ruff |
| **Make** | LuaSnip jsregexp build |

### DevOps Tools (for full feature support)

```bash
# Arch Linux
sudo pacman -S kubectl helm terraform ansible docker trivy awscli

# macOS
brew install kubectl helm terraform ansible trivy awscli azure-cli \
  google-cloud-sdk kubectx helmfile

# Ubuntu/Debian
sudo apt install -y kubectl docker.io ansible awscli
# terraform, helm, trivy via their official install scripts
```

---

## Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point — loads core and plugins
├── lazy-lock.json              # Pinned plugin versions
├── .stylua.toml                # Lua formatter config
├── lua/
│   ├── core/
│   │   ├── keymaps.lua         # All keybindings
│   │   ├── options.lua         # Neovim options (line numbers, tabs, etc.)
│   │   └── snippets.lua        # Diagnostics appearance config
│   ├── plugins/                # One file per plugin
│   │   ├── lsp.lua             # LSP servers + Mason
│   │   ├── autocompletion.lua  # nvim-cmp + LuaSnip
│   │   ├── none-ls.lua         # Formatters + linters via null-ls
│   │   ├── treesitter.lua      # Syntax highlighting
│   │   ├── telescope.lua       # Fuzzy finder
│   │   ├── neotree.lua         # File explorer
│   │   ├── toggleterm.lua      # Embedded terminal
│   │   ├── terraform.lua       # Terraform filetype support
│   │   ├── go.lua              # Go development
│   │   ├── dap.lua             # Debug adapter (Go)
│   │   ├── neotest.lua         # Test runner (Go)
│   │   └── ...
│   └── snippets/               # LuaSnip snippet libraries
│       ├── terraform.lua       # Terraform/HCL boilerplate
│       ├── yaml.lua            # k8s, Helm, ArgoCD, GitHub Actions, GitLab CI
│       ├── dockerfile.lua      # Dockerfile multi-stage patterns
│       └── sh.lua              # Bash scripting patterns
└── README.md
```

---

## LSP Servers

All servers are auto-installed by Mason on first launch.

| Server | Language / Tool | Completions | Diagnostics |
|---|---|---|---|
| `terraformls` | Terraform `.tf` | Resources, attributes, providers | Type errors, deprecated syntax |
| `yamlls` | YAML | Schema-aware (k8s, Helm, ArgoCD, GitHub Actions, etc.) | Schema validation |
| `gopls` | Go | Full IntelliSense, imports, placeholders | Nil checks, unused params |
| `ruff` | Python | — | Linting, import sorting |
| `pylsp` | Python | Completions, signatures | — |
| `bashls` | Bash / Shell | Variable/function completions | Shellcheck diagnostics |
| `lua_ls` | Lua | Neovim API aware | Globals, type checking |
| `jsonls` | JSON | Schema-aware completions | Validation |
| `ansiblels` | Ansible | Module completions | Task validation |
| `helm_ls` | Helm charts | Template completions | — |
| `docker_language_server` | Dockerfile | Instruction completions | Best practice hints |

### YAML Schema Awareness

`yamlls` is pre-configured with schemas for:
- Kubernetes (Deployment, Service, Ingress, etc.)
- GitHub Actions workflows (`.github/workflows/*.yml`)
- GitLab CI (`.gitlab-ci.yml`)
- ArgoCD Application / ApplicationSet
- Argo Workflows
- Kustomization
- Helmfile
- Renovate
- AWS SAM / CloudFormation
- Prometheus rules / Alertmanager
- Grafana dashboards

---

## Formatters & Linters

Powered by `none-ls.nvim`. All formatters run automatically on save.

| Tool | Filetypes | Type |
|---|---|---|
| `terraform_fmt` | `.tf`, `.tfvars` | Formatter |
| `stylua` | Lua | Formatter |
| `goimports` | Go | Formatter (imports + fmt) |
| `shfmt` | Bash/Shell | Formatter (4-space indent) |
| `prettier` | JSON, YAML, Markdown, CSS | Formatter |
| `ruff` / `ruff_format` | Python | Formatter + linter |
| `golangci_lint` | Go (requires `go.mod`) | Linter |
| `hadolint` | Dockerfile | Linter |
| `cfn_lint` | CloudFormation YAML | Linter |
| `checkmake` | Makefile | Linter |

---

## Snippets

Type the trigger word and press `<Tab>` to expand. Navigate between fields with `<Tab>` / `<S-Tab>`.

### Terraform (`.tf` files)

| Trigger | Scaffolds |
|---|---|
| `provider` | Generic provider block |
| `provider-aws` | AWS provider with region + profile |
| `provider-gcp` | Google Cloud provider |
| `provider-azurerm` | Azure provider |
| `resource` | Generic resource block |
| `variable` | Variable with type, description, default |
| `output` | Output block |
| `locals` | Locals block |
| `data` | Data source block |
| `module` | Module with source path |
| `backend-s3` | S3 backend with DynamoDB locking |
| `backend-gcs` | GCS backend |
| `backend-azurerm` | Azure backend |
| `required-providers` | Full terraform block with version constraints |
| `aws-ec2` | EC2 instance with tags |
| `aws-s3` | S3 bucket + versioning resource |
| `aws-sg` | Security group with ingress/egress |
| `aws-iam-role` | IAM role with assume role policy JSON |
| `aws-eks` | EKS cluster |
| `aws-rds` | RDS instance |
| `aws-vpc` | VPC |
| `common-tags` | locals block with standard tagging pattern |

### YAML (`.yaml` / `.yml` files)

**Kubernetes**

| Trigger | Scaffolds |
|---|---|
| `k8s-deployment` | Deployment with resources, envFrom, labels |
| `k8s-service` | Service with selector and port mapping |
| `k8s-ingress` | Ingress with TLS and nginx annotation |
| `k8s-configmap` | ConfigMap |
| `k8s-secret` | Secret (stringData) |
| `k8s-pvc` | PersistentVolumeClaim |
| `k8s-namespace` | Namespace with label |
| `k8s-serviceaccount` | ServiceAccount with IRSA annotation |
| `k8s-role` | RBAC Role |
| `k8s-rolebinding` | RoleBinding to ServiceAccount |
| `k8s-clusterrole` | ClusterRole |
| `k8s-clusterrolebinding` | ClusterRoleBinding |
| `k8s-hpa` | HorizontalPodAutoscaler (autoscaling/v2) |
| `k8s-cronjob` | CronJob |
| `k8s-networkpolicy` | NetworkPolicy with ingress/egress |

**ArgoCD**

| Trigger | Scaffolds |
|---|---|
| `argocd-app` | ArgoCD Application with automated sync |
| `argocd-appset` | ArgoCD ApplicationSet with list generator |

**GitHub Actions**

| Trigger | Scaffolds |
|---|---|
| `gh-workflow` | Full workflow with on/push/pull_request |
| `gh-job` | Single job with checkout step |
| `gh-docker-build` | Build + push to ECR via aws-actions |
| `gh-terraform` | Init → Plan → Apply pipeline |

**GitLab CI**

| Trigger | Scaffolds |
|---|---|
| `gl-pipeline` | Full pipeline with stages + variables |
| `gl-job` | Single job with artifacts |
| `gl-docker-build` | Docker build + push to GitLab registry |

**Helm**

| Trigger | Scaffolds |
|---|---|
| `helm-values` | Full `values.yaml` with image, service, ingress, resources, HPA |

### Dockerfile

| Trigger | Scaffolds |
|---|---|
| `df-go` | Go multi-stage build → distroless final image |
| `df-python` | Python multi-stage with `--user` pip install |
| `df-node` | Node.js multi-stage with `npm ci` |
| `df-multistage` | Generic multi-stage template |
| `df-simple` | Single-stage template |
| `df-run-apk` | `apk add` with cache cleanup |
| `df-run-apt` | `apt-get install` with cache cleanup |
| `df-healthcheck` | HEALTHCHECK instruction |
| `df-arg-env` | ARG + ENV pair |

### Bash (`.sh` files)

| Trigger | Scaffolds |
|---|---|
| `sh-header` | Script header with `set -euo pipefail` strict mode |
| `sh-log` | `log()` / `warn()` / `error()` helper functions |
| `sh-require` | Dependency checker — fails fast if tools missing |
| `sh-usage` | Usage/help function with heredoc |
| `sh-args` | `while`-based argument parser |
| `sh-retry` | Retry wrapper with configurable attempts and delay |
| `sh-trap` | `trap cleanup EXIT INT TERM` pattern |
| `ifel` | if/else block |
| `forin` | for loop over array |
| `whileread` | while read line-by-line loop |
| `sh-checkvar` | `: "${VAR:?'must be set'}"` guard |
| `sh-k8s-wait` | `kubectl rollout status` wait function |
| `sh-aws-profile` | AWS profile export + credential check |
| `sh-tf-deploy` | Terraform init → plan → apply function |
| `sh-docker-build` | Docker build + push with git SHA tag |
| `sh-tmpdir` | `mktemp -d` with auto-cleanup trap |

---

## Keybindings

**Leader key: `Space`**

### Navigation

| Key | Action | Why |
|---|---|---|
| `<C-h>` | Move focus to left window | Navigate into Neo-tree or left split |
| `<C-l>` | Move focus to right window | Navigate back to editor from Neo-tree |
| `<C-j>` | Move focus to window below | Split navigation |
| `<C-k>` | Move focus to window above | Split navigation |
| `<C-d>` | Scroll down + centre cursor | Keeps context centred while scrolling |
| `<C-u>` | Scroll up + centre cursor | Keeps context centred while scrolling |
| `n` / `N` | Next/prev search result + centre | Prevents search jumping off-screen |
| `<Tab>` | Next buffer | Cycle open files |
| `<S-Tab>` | Previous buffer | Cycle open files backwards |

### File Management

| Key | Action | Why |
|---|---|---|
| `<leader>e` | Toggle Neo-tree (left panel) | Open/close the file explorer |
| `\` | Neo-tree reveal current file | Jump to the current file in the tree |
| `<leader>ff` | Telescope: find files | Fuzzy search files by name |
| `<leader>fg` | Telescope: live grep | Search text across all files (needs ripgrep) |
| `<leader>fb` | Telescope: open buffers | Switch between open files via fuzzy picker |
| `<leader>fh` | Telescope: help tags | Search Neovim documentation |

**Inside Neo-tree:**

| Key | Action |
|---|---|
| `a` | Create new file (supports nested paths like `modules/vpc/main.tf`) |
| `A` | Create new directory |
| `r` | Rename file |
| `d` | Delete file |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `<Enter>` / `l` | Open file |
| `H` | Toggle hidden files |
| `/` | Fuzzy search within tree |

### Buffers & Windows

| Key | Action | Why |
|---|---|---|
| `<leader>x` | Close current buffer | Remove file from tab bar |
| `<leader>b` | New empty buffer | Open a blank scratch buffer |
| `<leader>v` | Split window vertically | Side-by-side editing (e.g. tf plan vs config) |
| `<leader>h` | Split window horizontally | Stacked editing |
| `<leader>se` | Equalise split sizes | Reset to even splits |
| `<leader>xs` | Close current split | Remove a split pane |
| `<Up/Down/Left/Right>` | Resize splits | Fine-tune split dimensions |

### Tabs

| Key | Action |
|---|---|
| `<leader>to` | Open new tab |
| `<leader>tx` | Close current tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |

### Saving & Quitting

| Key | Action | Why |
|---|---|---|
| `ZS` | Force save | Quick save without reaching for `:w` |
| `<leader>sn` | Save without auto-format | Preserve intentional formatting exceptions |
| `<C-q>` | Quit window | Close current window |

### LSP (active inside any LSP-supported file)

| Key | Action | Why |
|---|---|---|
| `gd` | Go to definition | Jump to where a resource/variable is defined |
| `gr` | Find all references | See everywhere a resource is used |
| `<leader>rn` | Rename symbol | Rename a variable/resource across all files |
| `<leader>ca` | Code action | Apply LSP fixes (import, quick-fix, etc.) |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |
| `<leader>d` | Show diagnostic float | Popup the full error message at cursor |
| `<leader>q` | Open diagnostics list | Show all errors in quickfix list |

### Snippets & Completion

| Key | Action | Why |
|---|---|---|
| `<Tab>` | Expand snippet OR jump to next field | Type trigger word + Tab = instant boilerplate |
| `<S-Tab>` | Jump to previous snippet field | Go back to fill in an earlier field |
| `<C-Space>` | Open completion menu manually | Trigger LSP suggestions mid-block |
| `<C-y>` | Confirm selected completion | Accept the highlighted suggestion |
| `<C-n>` / `<C-p>` | Next/previous completion item | Navigate the menu |
| `<C-b>` / `<C-f>` | Scroll docs up/down | Read the documentation popup |

### Terminal

| Key | Action | Why |
|---|---|---|
| `<leader>tt` | Toggle floating terminal | Quick shell access without leaving Neovim |

### DevOps Menus

| Key | Action | Why |
|---|---|---|
| `<leader>cc` | Cloud CLI commands menu | Quick reference for AWS/GCP/Azure/k8s/Docker/Vault/Consul CLI commands with yank support |
| `<leader>tv` | Trivy security scanner menu | Run Trivy scans (filesystem, image, k8s, IaC) directly from Neovim |

### Git

| Key | Action | Why |
|---|---|---|
| `<leader>ngs` | Neo-tree git status panel | Visual diff/stage panel |
| `]c` / `[c` | Next/prev git hunk | Navigate changed lines |
| `:G` | Fugitive git interface | Full git workflow in Neovim (`:G commit`, `:G push`, etc.) |

### Harpoon (file bookmarks)

Harpoon lets you pin frequently-used files and jump between them instantly — useful when working across multiple Terraform modules or k8s manifests simultaneously.

| Key | Action |
|---|---|
| `<leader>ha` | Add current file to Harpoon |
| `<leader>hh` | Open Harpoon quick menu |
| `<leader>h1` | Jump to Harpoon file 1 |
| `<leader>h2` | Jump to Harpoon file 2 |
| `<leader>h3` | Jump to Harpoon file 3 |
| `<leader>h4` | Jump to Harpoon file 4 |

### Diagnostics (Trouble)

| Key | Action |
|---|---|
| `<leader>xx` | Toggle Trouble panel |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |

### Go Development

| Key | Action |
|---|---|
| `<F5>` | DAP: continue / start debug session |
| `<F9>` | DAP: toggle breakpoint |
| `<F10>` | DAP: step over |
| `<F11>` | DAP: step into |
| `<F12>` | DAP: step out |
| `<leader>du` | DAP: toggle debug UI |
| `<leader>dc` | DAP: run to cursor |
| `<leader>dt` | DAP: terminate session |
| `<leader>de` | DAP: evaluate expression |
| `<leader>tr` | Neotest: run nearest test |
| `<leader>tf` | Neotest: run all tests in file |
| `<leader>ts` | Neotest: toggle summary panel |
| `<leader>to` | Neotest: open test output |
| `<leader>td` | Neotest: debug nearest test (DAP) |
| `<leader>tS` | Neotest: stop test run |

### Editing Helpers

| Key | Action | Why |
|---|---|---|
| `x` | Delete char (no clipboard) | Prevents single-char deletes from polluting the yank register |
| `p` (visual) | Paste without losing yank | Re-paste the same thing multiple times |
| `<` / `>` (visual) | Indent and stay in visual mode | Keeps selection for repeated indenting |
| `<leader>o` | Add empty line below | Add blank line without entering insert mode |
| `<leader>O` | Add empty line above | Add blank line without entering insert mode |
| `<leader>;` | Append `;` at end of line | Quick semicolon for scripting |
| `<leader>,` | Append `,` at end of line | Quick comma for arrays/maps |
| `<leader>lw` | Toggle line wrap | Useful for reading long YAML/HCL lines |

---

## Plugin List

| Plugin | Purpose |
|---|---|
| `lazy.nvim` | Plugin manager |
| `mason.nvim` + `mason-lspconfig` + `mason-tool-installer` | LSP / tool auto-installer |
| `nvim-lspconfig` | LSP client configuration |
| `nvim-cmp` + sources | Autocompletion engine |
| `LuaSnip` + `friendly-snippets` | Snippet engine + community snippets |
| `none-ls.nvim` | Formatters and linters as LSP |
| `nvim-treesitter` | AST-based syntax highlighting |
| `telescope.nvim` | Fuzzy finder |
| `neo-tree.nvim` | File explorer |
| `bufferline.nvim` | Buffer tab bar |
| `lualine.nvim` | Status line |
| `gitsigns.nvim` | Git gutter signs + hunk navigation |
| `vim-fugitive` + `vim-rhubarb` | Git commands + GitHub integration |
| `harpoon` | File bookmarks for rapid navigation |
| `toggleterm.nvim` | Embedded terminal |
| `trouble.nvim` | Diagnostic list panel |
| `which-key.nvim` | Keymap hints popup |
| `Comment.nvim` | Toggle comments (`gcc` / `gc` in visual) |
| `nvim-autopairs` | Auto-close brackets, quotes, braces |
| `indent-blankline.nvim` | Indent guide lines |
| `todo-comments.nvim` | Highlight `TODO:`, `FIXME:`, `NOTE:` in comments |
| `schemastore.nvim` | JSON/YAML schema registry |
| `vim-terraform` | Terraform filetype detection + `:Terraform` commands |
| `go.nvim` | Go tooling (generate, tags, test) |
| `nvim-dap` + `nvim-dap-ui` + `nvim-dap-go` | Go debugger |
| `neotest` + `neotest-go` | Go test runner |
| `vim-sleuth` | Auto-detect indentation from file |
| `vim-tmux-navigator` | Seamless pane navigation between Neovim and tmux |
| `fidget.nvim` | LSP progress indicator |
| `alpha-nvim` | Start screen dashboard |
| `tokyonight.nvim` | Colour theme |
| `cord.nvim` | Discord Rich Presence |

---

## Troubleshooting

### LSP not working
```
:LspInfo          — show attached servers for current buffer
:Mason            — open Mason to install/check server status
:checkhealth lsp  — full LSP health check
```

### Snippets not expanding
```
:lua print(#require('luasnip').get_snippets('terraform'))   — should be > 0
:set ft?                                                     — verify filetype detection
```

### Formatter not running on save
```
:LspInfo          — check null-ls is attached
:lua vim.lsp.buf.format()   — trigger format manually to see errors
```

### Plugins not loading
```
:Lazy             — open plugin manager
:Lazy check       — check for updates
:Lazy restore     — restore to lockfile versions
```

---

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — base configuration
- [Neovim](https://neovim.io/) — the editor
