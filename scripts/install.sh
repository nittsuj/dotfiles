#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

echo "=== 1. Installing Official Pacman Packages ==="
if [ -f "packages/pkglist.txt" ] && command -v pacman &> /dev/null; then
  sudo pacman -S --needed --noconfirm - < packages/pkglist.txt
fi

echo "=== 2. Bootstrapping yay (AUR helper) ==="
if [ -f "packages/aur-pkglist.txt" ] && command -v pacman &> /dev/null && ! command -v yay &> /dev/null; then
  YAY_TMP="$(mktemp -d)"
  git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$YAY_TMP/yay-bin"
  (cd "$YAY_TMP/yay-bin" && makepkg -si --noconfirm --needed)
  rm -rf "$YAY_TMP"
elif ! command -v yay &> /dev/null; then
  echo "yay is not installed and cannot be bootstrapped; skipping AUR packages."
fi

echo "=== 3. Installing AUR Packages ==="
if [ -f "packages/aur-pkglist.txt" ] && command -v yay &> /dev/null; then
  yay -S --needed --noconfirm - < packages/aur-pkglist.txt
fi

echo "=== 4. Installing VS Code Extensions ==="
if [ -f "packages/vscode-extensions.txt" ] && command -v code &> /dev/null; then
  while IFS= read -r extension || [ -n "$extension" ]; do
    if [ -n "$extension" ]; then
      code --install-extension "$extension" --force
    fi
  done < packages/vscode-extensions.txt
fi

mkdir -p ~/.ssh && chmod 700 ~/.ssh

echo "=== 5. Symlinking Dotfiles with GNU Stow ==="
stow fastfetch
stow kitty
stow nvim
stow zsh
stow git
stow ssh

echo "=== Enabling Git LFS ==="
git lfs install

echo "=== 6. Setting up Oh My Zsh, Powerlevel10k and Plugins ==="
# Cloned directly instead of using the omz installer, which would overwrite ~/.zshrc
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  echo "Oh My Zsh is already installed."
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "Powerlevel10k is already installed."
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "=== 7. Headlessly Syncing Neovim Plugins ==="
if command -v nvim &> /dev/null; then
  nvim --headless "+Lazy! sync" +qa
fi

echo "=== 8. Restoring GNOME Settings ==="
if command -v dconf &> /dev/null && [ -n "$DISPLAY$WAYLAND_DISPLAY" ]; then
  dconf load /org/gnome/ < gnome/gnome-settings.ini
else
  echo "Not in a graphical session; run later: dconf load /org/gnome/ < gnome/gnome-settings.ini"
fi

echo "=== Setup Complete! ==="
