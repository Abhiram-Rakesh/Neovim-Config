#!/usr/bin/env bash
#
# Neovim Config Installer
# Usage: curl -sL https://raw.githubusercontent.com/Abhiram-Rakesh/Neovim-Config/main/install.sh | bash
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Config
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
REPO_URL="https://github.com/Abhiram-Rakesh/Neovim-Config.git"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    local missing=()

    if ! command_exists git; then
        missing+=("git")
    fi

    if ! command_exists nvim; then
        missing+=("neovim")
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        echo ""
        echo "Install with:"
        echo "  macOS:  brew install git neovim"
        echo "  Ubuntu: sudo apt install git neovim"
        echo "  Arch:   sudo pacman -S git neovim"
        exit 1
    fi

    # Check Neovim version
    local nvim_version
    nvim_version=$(nvim --version | head -1 | grep -oP '\d+\.\d+' | head -1)
    local major minor
    major=$(echo "$nvim_version" | cut -d. -f1)
    minor=$(echo "$nvim_version" | cut -d. -f2)

    if [ "$major" -lt 0 ] || ([ "$major" -eq 0 ] && [ "$minor" -lt 10 ]; then
        log_warn "Neovim version is $nvim_version. Recommended: 0.10+"
    fi

    log_success "Prerequisites check passed"
}

# Backup existing config
backup_existing() {
    if [ -d "${NVIM_CONFIG_DIR}" ]; then
        log_info "Backing up existing config..."
        local backup_dir="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d%H%M%S)"
        mv "${NVIM_CONFIG_DIR}" "${backup_dir}"
        log_success "Backed up to ${backup_dir}"
    fi
}

# Install Neovim config
install_config() {
    log_info "Cloning Neovim config..."

    git clone --depth 1 "${REPO_URL}" "${NVIM_CONFIG_DIR}"

    log_success "Config cloned successfully"
}

# Install recommended tools
install_tools() {
    log_info "Checking for recommended DevOps tools..."

    local os
    os=$(uname -s)

    case "$os" in
        Darwin)
            if command_exists brew; then
                log_info "Installing tools via Homebrew..."
                local tools=(
                    "kubectl"
                    "terraform"
                    "ansible"
                    "trivy"
                    "helm"
                    "awscli"
                    "ripgrep"
                    "tree-sitter"
                )
                # Check what's already installed
                for tool in "${tools[@]}"; do
                    if ! command_exists "$tool" && [ "$tool" != "tree-sitter" ]; then
                        log_info "Consider installing: brew install $tool"
                    fi
                done
            fi
            ;;
        Linux)
            log_info "For Linux tools, consider your distro's package manager"
            log_info "Recommended: kubectl, terraform, trivy, helm, awscli, ripgrep"
            ;;
    esac

    log_success "Tool check complete"
}

# Post-install message
post_install() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Run the following to start Neovim:"
    echo "  nvim"
    echo ""
    echo "On first launch, Lazy.nvim will:"
    echo "  1. Download and install all plugins"
    echo "  2. Install LSP servers (may take a few minutes)"
    echo "  3. Install formatters and linters"
    echo ""
    echo "Key commands:"
    echo "  :Lazy          - Manage plugins"
    echo "  :Mason         - Install LSP/formatters"
    echo "  <leader>cc     - Cloud CLI commands"
    echo "  <leader>tv     - Trivy scanner"
    echo ""
}

# Main
main() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Neovim Config Installer            ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
    echo ""

    check_prerequisites
    backup_existing
    install_config
    install_tools
    post_install
}

# Run
main "$@"
