# Neovim Config - DevOps Ready

A production-ready Neovim configuration with comprehensive DevOps tooling support. Built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

![Neovim](https://img.shields.io/badge/Neovim-0.11+-57A143?style=flat&logo=neovim)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## Features

### Core Features
- **LSP Support** - Language Server Protocol for 15+ languages
- **Autocomplete** - nvim-cmp with LSP snippets
- **Formatting** - Prettier, Black, Go fmt, and more
- **Fuzzy Finding** - Telescope for file/search navigation
- **File Explorer** - NeoTree with git integration
- **Terminal** - ToggleTerm for embedded terminals
- **Git Integration** - Gitsigns for git gutter

### DevOps Tools
| Category | Tools |
|----------|-------|
| **IaC** | Terraform, CloudFormation, Ansible |
| **Containers** | Docker, Docker Compose, Hadolint |
| **Kubernetes** | kubectl, Helm, Kustomize, ArgoCD |
| **Cloud** | AWS, GCP, Azure CLI snippets |
| **Security** | Trivy, Vault (ecolog.nvim), Gitleaks |
| **Monitoring** | Prometheus, AlertManager, Grafana |
| **CI/CD** | GitHub Actions, GitLab CI |

## Quick Install

```bash
# One-command install
curl -sL https://raw.githubusercontent.com/Abhiram-Rakesh/Neovim-Config/main/install.sh | bash
```

Or manually:

```bash
# Clone the repo
git clone https://github.com/Abhiram-Rakesh/Neovim-Config.git ~/.config/nvim

# Start Neovim
nvim
```

## Prerequisites

- **Neovim 0.11+** (or 0.10.x with [v0.10 branch](https://github.com/Abhiram-Rakesh/Neovim-Config/tree/v0.10))
- **Git**
- **Ripgrep** - For Telescope live_grep
- **Node.js** - For LSP servers (optional, managed by Mason)
- **Python** - For Python LSP (optional)

### Optional Tools (for full DevOps support)

```bash
# macOS
brew install \
  kubectl \
  terraform \
  ansible \
  docker \
  trivy \
  helm \
  k9s \
  awscli \
  gcloud \
  azure-cli \
  cloud-native-toolkit \
  kubectx

# Ubuntu/Debian
sudo apt install -y \
  kubectl \
  terraform \
  ansible \
  docker.io \
  trivy \
  helm \
  awscli \
  google-cloud-sdk \
  azure-cli

# Go (for various tools)
go install github.com/aquasecurity/trivy@latest
go install github.com/helmfile/helmfile@latest
```

## Keybindings

### General
| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `Ctrl + d/u` | Scroll and center |
| `Ctrl + w + h/j/k/l` | Navigate splits |
| `Tab` | Next buffer |
| `S-Tab` | Previous buffer |

### Files & Search
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Open buffers |
| `<leader>lp` | Live preview (Markdown) |

### DevOps
| Key | Action |
|-----|--------|
| `<leader>cc` | Cloud CLI commands menu |
| `<leader>tv` | Trivy security scanner menu |

### Git
| Key | Action |
|-----|--------|
| `<leader>xx` | Trouble (diagnostics) |
| `]c` / `[c` | Next/prev git hunk |

## Project Structure

```
nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Dependency lockfile
├── .stylua.toml         # Code formatter config
├── lua/
│   ├── core/
│   │   ├── keymaps.lua  # Keybindings
│   │   ├── options.lua  # Neovim options
│   │   └── snippets.lua # Custom snippets
│   └── plugins/
│       ├── lsp.lua      # LSP configuration
│       ├── lualine.lua  # Statusline
│       ├── telescope.lua # Fuzzy finder
│       └── ...          # Other plugins
└── README.md
```

## Language Support

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Go | gopls | gofmt, goimports | golangci-lint |
| Python | pylsp, ruff | ruff | ruff |
| TypeScript | ts_ls | prettier | eslint |
| Rust | rust_analyzer | rustfmt | clippy |
| Docker | dockerls | - | hadolint |
| Terraform | terraformls | terraform_fmt | checkov |
| YAML | yamlls | prettier | - |
| Lua | lua_ls | stylua | - |

## Updating

```bash
# Update plugins
:Lazy

# Check for updates
:Lazy check
```

## Troubleshooting

### Plugins not loading
```bash
# Clear cache and reinstall
:Lazy clear
:Lazy restore
```

### LSP not working
```bash
# Install LSP servers
:Mason

# Check LSP status
:LspInfo
```

### Format on save not working
```bash
# Check attached clients
:LspAttach
```

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Base configuration
- [LazyVim](https://github.com/LazyVim/LazyVim) - Plugin inspiration
- [Neovim](https://neovim.io/) - The editor

## License

MIT License - See [LICENSE](LICENSE) for details.
