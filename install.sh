#!/usr/bin/env bash
#  ██
#
# ░██   ░██     ██
# ░██   ░████   ██
# ░██   ░██ ░██ ██
# ░██   ░██  ░████
# ░██   ░██   ░███
# ░░░   ░░░    ░░░ stall
#
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ grokon
# ░▓ code   ▓ https://git.io/JJGii
# ░▓ File:  ▓ install.sh
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░
#
# =============================================================== #

set -euo pipefail

# Configuration
DOTPATH="${HOME}/.dotfiles"
USER=$(whoami)
[[ -z ${XDG_CONFIG_HOME:-} ]] && XDG_CONFIG_HOME="${HOME}/.config"
INSTALL_LOG="${DOTPATH}/.install.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Utility functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "${INSTALL_LOG}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
    echo "[WARNING] $1" >> "${INSTALL_LOG}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    echo "[ERROR] $1" >> "${INSTALL_LOG}"
    exit 1
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if package is installed via apt
apt_package_installed() {
    dpkg -l | grep -q "^ii  $1 "
}

# Check if something was already installed (logged)
already_installed() {
    [[ -f "${INSTALL_LOG}" ]] && grep -q "INSTALLED: $1" "${INSTALL_LOG}"
}

# Mark as installed
mark_installed() {
    echo "INSTALLED: $1" >> "${INSTALL_LOG}"
}

# Ask user confirmation
ask() {
    echo -n ":: Press y to $1: "
    read -r result </dev/tty
    [[ ${result} == "y" ]]
}

# Create necessary directories
mkdir -p "${XDG_CONFIG_HOME}"
mkdir -p "$(dirname "${INSTALL_LOG}")" 2>/dev/null || true

log "Starting dotfiles installation/update"

# =============================================================== #
# System packages installation
# =============================================================== #

install_system_packages() {
    if already_installed "system_packages"; then
        log "System packages already installed, skipping..."
        return 0
    fi

    log "Updating package lists..."
    sudo apt-get update && sudo apt-get upgrade -y

    log "Installing essential system packages..."
    local packages=(
        "git"  # Minimal git version needed for cloning dotfiles
        "curl" 
        "wget"
        "unzip"  # Needed for extracting archives
        "build-essential"
        "gcc"
        "make"
    		"zsh"  # Popular shell, requested by user
        "software-properties-common"
        "apt-transport-https"
        "ca-certificates"
        "gnupg"
        "lsb-release"
				"socat"   # Socket tools
				"net-tools"  # Network utilities
    )
    
    local missing_packages=()
    for package in "${packages[@]}"; do
        if ! apt_package_installed "$package"; then
            missing_packages+=("$package")
        fi
    done

    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log "Installing missing packages: ${missing_packages[*]}"
        sudo apt-get install -y "${missing_packages[@]}"
    else
        log "All system packages already installed"
    fi

    mark_installed "system_packages"
}

# =============================================================== #
# Homebrew installation
# =============================================================== #

install_homebrew() {
    if already_installed "homebrew"; then
        log "Homebrew already installed, skipping..."
        return 0
    fi

    if command_exists brew; then
        log "Homebrew already exists"
    else
        log "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Add to PATH for current session
    if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    mark_installed "homebrew"
}

# =============================================================== #
# Modern tools via Homebrew
# =============================================================== #

install_modern_tools() {
    if already_installed "modern_tools"; then
        log "Modern tools already installed, skipping..."
        return 0
    fi

    if ! command_exists brew; then
        error "Homebrew not found. Please install homebrew first."
    fi

    log "Installing modern development tools via Homebrew..."
    local brew_packages=(
        "neovim"
        "git"
        "jq"
        "ripgrep"
        "fd"
        "fzf"
        "bat"
        "tmux"
        "node@22"
        "fish"
        "eza"        # Modern replacement for ls
        "zoxide"     # Smart directory navigation
        "lazygit"    # Terminal UI for git
        "htop"       # Interactive process viewer
        "tree"       # Display directory structure
        "gh"         # GitHub CLI
        "delta"      # Better git diff viewer
        "dust"       # Modern du replacement
        "duf"        # Modern df replacement
        "procs"      # Modern ps replacement
    )

    local missing_brew_packages=()
    for package in "${brew_packages[@]}"; do
        if ! brew list "$package" >/dev/null 2>&1; then
            missing_brew_packages+=("$package")
        fi
    done

    if [[ ${#missing_brew_packages[@]} -gt 0 ]]; then
        log "Installing missing Homebrew packages: ${missing_brew_packages[*]}"
        brew install "${missing_brew_packages[@]}"
    else
        log "All Homebrew packages already installed"
    fi

    mark_installed "modern_tools"
    
}

# =============================================================== #
# Docker installation
# =============================================================== #

install_docker() {
    if already_installed "docker"; then
        log "Docker already installed, skipping..."
        return 0
    fi

    if command_exists docker; then
        log "Docker already exists"
    else
        log "Installing Docker..."
        sudo mkdir -m 0755 -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi

    # Add user to docker group if not already added
    if ! groups "${USER}" | grep -q docker; then
        log "Adding user ${USER} to docker group..."
        sudo usermod -aG docker "${USER}"
        warn "You need to log out and back in for docker group changes to take effect"
    fi

    mark_installed "docker"
}

# =============================================================== #
# Dotfiles installation
# =============================================================== #

install_dotfiles() {
    if already_installed "dotfiles_cloned"; then
        log "Dotfiles already cloned, updating..."
        if [[ -d "${DOTPATH}" ]]; then
            cd "${DOTPATH}" && git pull && cd ~
        fi
    else
        log "Cloning dotfiles repository..."
        if [[ ! -d "${DOTPATH}" ]]; then
            git clone https://github.com/Grokon/dotfiles.git "${DOTPATH}"
            mark_installed "dotfiles_cloned"
        fi
    fi
}

# =============================================================== #
# Create symlinks
# =============================================================== #

create_symlinks() {
    if already_installed "symlinks"; then
        log "Symlinks already created, skipping..."
        return 0
    fi

    log "Creating symlinks..."
    cd "${DOTPATH}"
    
    for file in .??*; do
        [[ ${file} == ".git" ]] && continue
        [[ ${file} == ".DS_Store" ]] && continue
        [[ ${file} == ".install.log" ]] && continue
        
        if [[ ${file} == ".bin" ]]; then
            mkdir -p "${HOME}/bin"
            find "${DOTPATH}/.bin/" -type f -perm 0755 -exec ln -fvns {} "${HOME}/bin/" \; 2>/dev/null || true
            continue
        fi
        
        if [[ ${file} == ".config" ]]; then
            find "${DOTPATH}/.config" -maxdepth 1 -mindepth 1 -exec ln -fvns {} "${XDG_CONFIG_HOME}/" \; 2>/dev/null || true
            continue
        fi
        
        if [[ ${file} == ".gnupg" ]]; then
            if [[ -L "${HOME}/${file}" ]]; then
                ls -lah "${HOME}/${file}"
                if ! ask "remove ${HOME}/${file}"; then
                    log "Skipping ${file}"
                    continue
                fi
                rm -rf "${HOME}/${file:?}"
            fi
            mkdir -p "${HOME}/.gnupg"
            chmod 700 "${HOME}/.gnupg"
            find "${DOTPATH}/.gnupg" -maxdepth 1 -mindepth 1 -exec ln -fvns {} "${HOME}/.gnupg" \; 2>/dev/null || true
            continue
        fi
        
        if [[ ! -L "${HOME}/${file}" ]]; then
            if [[ -f "${HOME}/${file}" ]]; then
                ls -lah "${HOME}/${file}"
                if ! ask "remove ${HOME}/${file}"; then
                    log "Skipping ${file}"
                    continue
                fi
                rm -rf "${HOME}/${file:?}"
            fi
            ln -fvns "${DOTPATH}/${file}" "${HOME}/${file}"
        fi
    done
    
    cd "${HOME}"
    mark_installed "symlinks"
}

# =============================================================== #
# Tmux plugin manager
# =============================================================== #

install_tmux_plugins() {
    if already_installed "tmux_plugins"; then
        log "Tmux plugins already installed, skipping..."
        return 0
    fi

    local tpm_dir="${HOME}/.tmux/plugins/tpm"
    if [[ ! -d "${tpm_dir}" ]]; then
        log "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "${tpm_dir}"
        if [[ -f "${tpm_dir}/bin/install_plugins" ]]; then
            "${tpm_dir}/bin/install_plugins"
        fi
    else
        log "Tmux Plugin Manager already installed"
    fi

    mark_installed "tmux_plugins"
}

# =============================================================== #
# WSL configuration
# =============================================================== #

configure_wsl() {
    if already_installed "wsl_config"; then
        log "WSL already configured, skipping..."
        return 0
    fi

    if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
        log "WSL detected - configuring WSL settings..."
        
        # Configure WSL settings
        sudo tee /etc/wsl.conf > /dev/null << 'EOF'
[automount]
options = "metadata,umask=22,fmask=11"

# Set a command to run when a new WSL instance launches.
[boot]
command = service docker start
EOF
        log "WSL configuration updated"
        
        # Install npiperelay for Windows integration
        install_npiperelay
        
        mark_installed "wsl_config"
    fi
}

# =============================================================== #
# Install npiperelay for WSL
# =============================================================== #

install_npiperelay() {
    if already_installed "npiperelay"; then
        log "npiperelay already installed, skipping..."
        return 0
    fi

    log "Installing npiperelay for Windows integration..."
    
    local npiperelay_target="/usr/local/bin/npiperelay.exe"
    
    # Check if npiperelay is already installed
    if [[ -f "${npiperelay_target}" ]]; then
        log "npiperelay.exe already exists at ${npiperelay_target}"
        mark_installed "npiperelay"
        return 0
    fi
    
    # Get the latest release URL from GitHub API
    log "Fetching latest npiperelay release information..."
    local latest_zip_url
    latest_zip_url=$(curl -s https://api.github.com/repos/jstarks/npiperelay/releases/latest | grep -o '"browser_download_url": "[^"]*amd64\.zip"' | cut -d'"' -f4 || true)
    
    if [[ -z "${latest_zip_url}" ]]; then
        warn "Could not fetch latest npiperelay release URL from GitHub API"
        warn "Using fallback download URL..."
        # Fallback to a known working version
        latest_zip_url="https://github.com/jstarks/npiperelay/releases/download/v0.1.0/npiperelay_windows_amd64.zip"
    fi
    
    log "Downloading npiperelay from: ${latest_zip_url}"
    
    # Create temporary directory
    local temp_dir="/tmp/npiperelay_install"
    mkdir -p "${temp_dir}"
    
    # Download and extract npiperelay
    if curl -fsSL "${latest_zip_url}" -o "${temp_dir}/npiperelay.zip"; then
        log "Extracting npiperelay.exe..."
        if command_exists unzip; then
            if unzip -q "${temp_dir}/npiperelay.zip" -d "${temp_dir}/"; then
                # Find the .exe file in extracted contents
                local exe_file
                exe_file=$(find "${temp_dir}" -name "*.exe" -type f | head -1)
                
                if [[ -f "${exe_file}" ]]; then
                    log "Installing npiperelay.exe to ${npiperelay_target}..."
                    sudo mv "${exe_file}" "${npiperelay_target}"
                    sudo chmod 755 "${npiperelay_target}"
                    log "npiperelay.exe installed successfully"
                else
                    error "Could not find npiperelay.exe in downloaded archive"
                fi
            else
                error "Failed to extract npiperelay archive"
            fi
        else
            error "unzip command not found. Please install unzip package."
        fi
        
        # Cleanup
        rm -rf "${temp_dir}"
    else
        warn "Failed to download npiperelay archive"
        warn "You can manually download it from: https://github.com/jstarks/npiperelay/releases"
        warn "And place npiperelay.exe in: ${npiperelay_target}"
        return 1
    fi
    
    mark_installed "npiperelay"
}

# =============================================================== #
# Set default shell
# =============================================================== #

set_default_shell() {
    if already_installed "default_shell"; then
        log "Default shell already set, skipping..."
        return 0
    fi

    local current_shell
    current_shell=$(getent passwd "${USER}" | cut -d: -f7)
    local fish_path="/usr/bin/fish"
    
    # Try homebrew fish first
    if command -v brew >/dev/null 2>&1; then
        local brew_fish
        brew_fish="$(brew --prefix)/bin/fish"
        if [[ -f "${brew_fish}" ]]; then
            fish_path="${brew_fish}"
        fi
    fi

    if [[ "${current_shell}" != "${fish_path}" ]]; then
        if [[ -f "${fish_path}" ]]; then
            log "Changing default shell to fish (${fish_path})..."
            
            # Add fish to /etc/shells if not present
            if ! grep -q "${fish_path}" /etc/shells; then
                echo "${fish_path}" | sudo tee -a /etc/shells
            fi
            
            sudo chsh -s "${fish_path}" "${USER}"
            log "Default shell changed to fish. Please log out and back in for changes to take effect."
        else
            warn "Fish shell not found at ${fish_path}"
        fi
    else
        log "Fish is already the default shell"
    fi

    mark_installed "default_shell"
}

# =============================================================== #
# Main installation flow
# =============================================================== #

main() {
    info "Starting dotfiles installation/update process..."
    info "Installation log: ${INSTALL_LOG}"
    
    # Step 1: System packages (including minimal git)
    install_system_packages
    
    # Step 2: Clone/update dotfiles (early, so config is available)
    install_dotfiles
    
    # Step 3: Homebrew (provides modern versions of tools)
    install_homebrew
    
    # Step 4: Modern development tools via Homebrew (updates git, installs node, etc.)
    install_modern_tools
    
    # Step 5: Docker
    install_docker
    
    # Step 6: Create symlinks
    create_symlinks
    
    # Step 7: Tmux plugins
    install_tmux_plugins
    
    # Step 8: WSL configuration
    configure_wsl
    
    # Step 9: Set default shell
    set_default_shell
    
    log "Installation completed successfully!"
    info "Please log out and back in to ensure all changes take effect."
    
    if grep -q "docker" "${INSTALL_LOG}" && ! groups "${USER}" | grep -q docker 2>/dev/null; then
        warn "You were added to the docker group. Please log out and back in to use docker without sudo."
    fi
}

# Run main function
main "$@"