#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

echo "=== 1. Installing Official Pacman Packages ==="
if [ -f "config/pkglist.txt" ] && command -v pacman &> /dev/null; then
  sudo pacman -S --needed --noconfirm - < config/pkglist.txt
fi

echo "=== 2. Installing AUR Packages ==="
if [ -f "config/aur-pkglist.txt" ] && command -v yay &> /dev/null; then
  yay -S --needed --noconfirm - < config/aur-pkglist.txt
fi

echo "=== 3. Symlinking Dotfiles with GNU Stow ==="
stow config
stow zsh

echo "=== 4. Installing Starship Prompt ==="
if ! command -v starship &> /dev/null; then
  if command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm starship
  else
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
else
  echo "Starship is already installed."
fi

echo "=== 5. Setting up Oh My Zsh Plugins ==="
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "=== 6. Restoring VS Code Extensions ==="
if command -v code-oss &> /dev/null; then
  cat config/vscode-extensions.txt | xargs -L 1 code-oss --install-extension
elif command -v code &> /dev/null; then
  cat config/vscode-extensions.txt | xargs -L 1 code --install-extension
fi

echo "=== 7. Headlessly Syncing Neovim Plugins ==="
if command -v nvim &> /dev/null; then
  nvim --headless "+Lazy! sync" +qa
fi

echo "=== Setup Complete! ==="
