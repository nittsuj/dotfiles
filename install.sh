#!/usr/bin/env bash

set -e

echo "=== 1. Symlinking Dotfiles with GNU Stow ==="
cd "$(dirname "$0")"
stow config
stow zsh

echo "=== 2. Setting up Oh My Zsh Plugins ==="
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "=== 3. Restoring VS Code Extensions ==="
if command -v code-oss &> /dev/null; then
  cat config/vscode-extensions.txt | xargs -L 1 code-oss --install-extension
elif command -v code &> /dev/null; then
  cat config/vscode-extensions.txt | xargs -L 1 code --install-extension
fi

echo "=== Setup Complete! ==="
