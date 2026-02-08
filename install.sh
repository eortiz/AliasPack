#!/bin/bash

# install.sh - Install aliaspak by adding a single source line to your shell config
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#
# The repo should be at ~/aliaspak/ for the sourcing paths to work.

set -e

ALIASPAK_DIR="$HOME/aliaspak"
SOURCE_LINE="source $ALIASPAK_DIR/alias_pack"

echo "################################"
echo " Installing Alias Pack"
echo "################################"
echo ""

# Verify alias_pack exists in expected location
if [ ! -f "$ALIASPAK_DIR/alias_pack" ]; then
  echo "Error: alias_pack not found at $ALIASPAK_DIR/"
  echo "Please clone or move this repo to ~/aliaspak/ first."
  exit 1
fi

# Detect the best shell config file to modify
#
# Priority:
#   Zsh + oh-my-zsh → $ZSH_CUSTOM/aliaspak.zsh  (auto-sourced by oh-my-zsh)
#   Zsh             → ~/.zshrc
#   Bash            → ~/.bash_aliases if it exists (purpose-built for aliases)
#   Bash            → ~/.bashrc
#   Other           → ~/.profile
detect_config_file() {
  local shell_name
  shell_name=$(basename "$SHELL")

  case "$shell_name" in
    zsh)
      if [ -d "$HOME/.oh-my-zsh" ]; then
        local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
        echo "$zsh_custom/aliaspak.zsh"
      else
        echo "$HOME/.zshrc"
      fi
      ;;
    bash)
      if [ -f "$HOME/.bash_aliases" ]; then
        echo "$HOME/.bash_aliases"
      else
        echo "$HOME/.bashrc"
      fi
      ;;
    *)
      echo "$HOME/.profile"
      ;;
  esac
}

CONFIG_FILE=$(detect_config_file)

echo "Shell:  $(basename "$SHELL")"
echo "Config: $CONFIG_FILE"
echo ""

# Check if already installed
if [ -f "$CONFIG_FILE" ] && grep -qF "$SOURCE_LINE" "$CONFIG_FILE"; then
  echo "aliaspak is already sourced in $CONFIG_FILE - nothing to do."
  exit 0
fi

# Create parent directory if needed (for oh-my-zsh custom dir)
mkdir -p "$(dirname "$CONFIG_FILE")"

# Add the source line
{
  echo ""
  echo "# aliaspak - modular bash aliases and functions"
  echo "$SOURCE_LINE"
} >> "$CONFIG_FILE"

echo "Added to $CONFIG_FILE:"
echo "  $SOURCE_LINE"
echo ""
echo "To activate now, run:"
echo "  source $CONFIG_FILE"
echo ""
echo "Done!"
