#!/usr/bin/env bash

# deasy Installation Script
# Automated setup for the deasy YouTube downloader

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Configuration
SCRIPT_URL="https://raw.githubusercontent.com/yourusername/deasy/main/deasy.sh"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="deasy"
BACKUP_SUFFIX=".backup"

# Helper functions
print_header() {
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}${CYAN}  deasy Installation Script${RESET}"
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo
}

print_success() {
  echo -e "${GREEN}✓${RESET} $1"
}

print_error() {
  echo -e "${RED}✗${RESET} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${RESET} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${RESET} $1"
}

# Check if command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Detect shell type
detect_shell() {
  if [ -n "$BASH_VERSION" ]; then
    echo "bash"
  elif [ -n "$ZSH_VERSION" ]; then
    echo "zsh"
  else
    # Fallback to checking SHELL variable
    case "$SHELL" in
      */bash) echo "bash" ;;
      */zsh) echo "zsh" ;;
      *) echo "unknown" ;;
    esac
  fi
}

# Get shell config file
get_shell_config() {
  local shell_type=$(detect_shell)
  case "$shell_type" in
    bash)
      if [ -f "$HOME/.bashrc" ]; then
        echo "$HOME/.bashrc"
      else
        echo "$HOME/.bash_profile"
      fi
      ;;
    zsh)
      echo "$HOME/.zshrc"
      ;;
    *)
      echo ""
      ;;
  esac
}

# Check and install yt-dlp
check_ytdlp() {
  echo -e "${BOLD}Step 1: Checking yt-dlp...${RESET}"
  
  if command_exists yt-dlp; then
    local version=$(yt-dlp --version 2>/dev/null || echo "unknown")
    print_success "yt-dlp is already installed (version: $version)"
    return 0
  fi
  
  print_warning "yt-dlp is not installed"
  echo
  echo "deasy requires yt-dlp to function. Would you like to install it now?"
  echo
  echo "Installation options:"
  echo "  1) Install via pip (recommended)"
  echo "  2) Install via system package manager"
  echo "  3) Skip (install manually later)"
  echo
  read -p "Choose an option [1-3]: " choice
  
  case "$choice" in
    1)
      if command_exists pip3; then
        echo "Installing yt-dlp via pip3..."
        pip3 install --user yt-dlp
        print_success "yt-dlp installed successfully"
      elif command_exists pip; then
        echo "Installing yt-dlp via pip..."
        pip install --user yt-dlp
        print_success "yt-dlp installed successfully"
      else
        print_error "pip is not installed. Please install Python and pip first."
        return 1
      fi
      ;;
    2)
      echo
      print_info "Please install yt-dlp using your package manager:"
      echo
      echo "  Ubuntu/Debian:  sudo apt install yt-dlp"
      echo "  Fedora:         sudo dnf install yt-dlp"
      echo "  Arch Linux:     sudo pacman -S yt-dlp"
      echo "  macOS:          brew install yt-dlp"
      echo
      read -p "Press Enter after installing yt-dlp..."
      
      if command_exists yt-dlp; then
        print_success "yt-dlp detected"
      else
        print_error "yt-dlp not found. Please install it and run this script again."
        return 1
      fi
      ;;
    3)
      print_warning "Skipping yt-dlp installation"
      print_info "Remember to install yt-dlp before using deasy"
      ;;
    *)
      print_error "Invalid option"
      return 1
      ;;
  esac
  
  echo
}

# Check and install ffmpeg
check_ffmpeg() {
  echo -e "${BOLD}Step 2: Checking ffmpeg...${RESET}"
  
  if command_exists ffmpeg; then
    local version=$(ffmpeg -version 2>/dev/null | head -n1 | cut -d' ' -f3 || echo "unknown")
    print_success "ffmpeg is already installed (version: $version)"
    return 0
  fi
  
  print_warning "ffmpeg is not installed (required for format conversion)"
  echo
  echo "Would you like to install ffmpeg now?"
  echo "  1) Yes, show me the installation commands"
  echo "  2) Skip (install manually later)"
  echo
  read -p "Choose an option [1-2]: " choice
  
  case "$choice" in
    1)
      echo
      print_info "Install ffmpeg using your package manager:"
      echo
      echo "  Ubuntu/Debian:  sudo apt install ffmpeg"
      echo "  Fedora:         sudo dnf install ffmpeg"
      echo "  Arch Linux:     sudo pacman -S ffmpeg"
      echo "  macOS:          brew install ffmpeg"
      echo
      read -p "Press Enter after installing ffmpeg..."
      
      if command_exists ffmpeg; then
        print_success "ffmpeg detected"
      else
        print_warning "ffmpeg not found. Some features may not work."
      fi
      ;;
    2)
      print_warning "Skipping ffmpeg installation"
      print_info "Some format conversions may not work without ffmpeg"
      ;;
    *)
      print_error "Invalid option"
      ;;
  esac
  
  echo
}

# Install deasy script
install_deasy() {
  echo -e "${BOLD}Step 3: Installing deasy...${RESET}"
  
  # Create install directory if it doesn't exist
  if [ ! -d "$INSTALL_DIR" ]; then
    print_info "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
  fi
  
  local script_path="$INSTALL_DIR/$SCRIPT_NAME"
  
  # Backup existing installation
  if [ -f "$script_path" ]; then
    print_warning "Existing installation found"
    echo "Creating backup: ${script_path}${BACKUP_SUFFIX}"
    cp "$script_path" "${script_path}${BACKUP_SUFFIX}"
  fi
  
  # Check if we're running from the deasy.sh file
  local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local source_script="$current_dir/deasy.sh"
  
  if [ -f "$source_script" ]; then
    print_info "Installing from local file: $source_script"
    cp "$source_script" "$script_path"
  else
    # Try to download from URL (if you host it online)
    print_info "Attempting to download deasy from repository..."
    if command_exists curl; then
      curl -fsSL "$SCRIPT_URL" -o "$script_path" 2>/dev/null || {
        print_error "Failed to download. Please ensure deasy.sh is in the current directory."
        return 1
      }
    elif command_exists wget; then
      wget -qO "$script_path" "$SCRIPT_URL" 2>/dev/null || {
        print_error "Failed to download. Please ensure deasy.sh is in the current directory."
        return 1
      }
    else
      print_error "Neither curl nor wget found. Cannot download script."
      print_info "Please place deasy.sh in the current directory and run this installer again."
      return 1
    fi
  fi
  
  # Make executable
  chmod +x "$script_path"
  
  print_success "deasy installed to: $script_path"
  echo
}

# Configure shell
configure_shell() {
  echo -e "${BOLD}Step 4: Configuring shell...${RESET}"
  
  local shell_config=$(get_shell_config)
  
  if [ -z "$shell_config" ]; then
    print_warning "Could not detect shell configuration file"
    print_info "Please manually add $INSTALL_DIR to your PATH"
    return 1
  fi
  
  print_info "Detected shell config: $shell_config"
  
  # Check if PATH already contains the install directory
  if echo "$PATH" | grep -q "$INSTALL_DIR"; then
    print_success "PATH already includes $INSTALL_DIR"
    return 0
  fi
  
  # Check if config file already has the PATH entry
  if [ -f "$shell_config" ] && grep -q "$INSTALL_DIR" "$shell_config"; then
    print_success "Shell config already includes $INSTALL_DIR"
    return 0
  fi
  
  echo
  echo "Would you like to add $INSTALL_DIR to your PATH?"
  echo "This will be added to: $shell_config"
  echo
  read -p "Add to PATH? [Y/n]: " response
  
  if [[ ! "$response" =~ ^[Nn] ]]; then
    echo "" >> "$shell_config"
    echo "# Added by deasy installer" >> "$shell_config"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$shell_config"
    print_success "PATH updated in $shell_config"
    print_info "Run 'source $shell_config' or restart your terminal to apply changes"
  else
    print_warning "Skipped PATH configuration"
    print_info "You'll need to add $INSTALL_DIR to your PATH manually"
  fi
  
  echo
}

# Verify installation
verify_installation() {
  echo -e "${BOLD}Step 5: Verifying installation...${RESET}"
  
  # Export PATH for this session
  export PATH="$INSTALL_DIR:$PATH"
  
  if command_exists deasy; then
    print_success "deasy command is available"
    
    # Test basic functionality
    if deasy -h &>/dev/null || deasy --help &>/dev/null || deasy &>/dev/null; then
      print_success "deasy is working correctly"
    else
      print_warning "deasy may not be functioning properly"
    fi
  else
    print_error "deasy command not found in PATH"
    print_info "You may need to restart your terminal or run:"
    echo "    source $(get_shell_config)"
  fi
  
  echo
}

# Print completion message
print_completion() {
  echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}${GREEN}  Installation Complete!${RESET}"
  echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo
  echo -e "${BOLD}Quick Start:${RESET}"
  echo
  echo "  1. Restart your terminal or run:"
  echo -e "     ${CYAN}source $(get_shell_config)${RESET}"
  echo
  echo "  2. Try deasy:"
  echo -e "     ${CYAN}deasy https://youtube.com/watch?v=...${RESET}"
  echo
  echo "  3. Get help:"
  echo -e "     ${CYAN}deasy${RESET} (shows help menu)"
  echo
  echo -e "${BOLD}Example commands:${RESET}"
  echo -e "  ${CYAN}deasy audio https://youtube.com/watch?v=...${RESET}"
  echo -e "  ${CYAN}deasy 720 mkv https://youtube.com/watch?v=...${RESET}"
  echo -e "  ${CYAN}deasy playlist https://youtube.com/playlist?list=...${RESET}"
  echo
  print_success "Enjoy using deasy!"
  echo
}

# Main installation flow
main() {
  print_header
  
  # Run installation steps
  check_ytdlp || exit 1
  check_ffmpeg
  install_deasy || exit 1
  configure_shell
  verify_installation
  
  print_completion
}

# Run main function
main
