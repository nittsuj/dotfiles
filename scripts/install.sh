#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help) echo "Usage: $0 [-n|--dry-run]"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

# Print instead of run when --dry-run is set
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '+'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

echo "=== 1. Installing Official Pacman Packages ==="
if [ -f "packages/pkglist.txt" ] && command -v pacman &> /dev/null; then
  run sudo pacman -S --needed --noconfirm - < packages/pkglist.txt
fi

echo "=== 2. Bootstrapping yay (AUR helper) ==="
if [ -f "packages/aur-pkglist.txt" ] && command -v pacman &> /dev/null && ! command -v yay &> /dev/null; then
  if [ "$DRY_RUN" = 1 ]; then
    echo "+ build and install yay-bin from the AUR"
  else
    YAY_TMP="$(mktemp -d)"
    git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$YAY_TMP/yay-bin"
    (cd "$YAY_TMP/yay-bin" && makepkg -si --noconfirm --needed)
    rm -rf "$YAY_TMP"
  fi
elif ! command -v yay &> /dev/null; then
  echo "yay is not installed and cannot be bootstrapped; skipping AUR packages."
fi

echo "=== 3. Installing AUR Packages ==="
if [ -f "packages/aur-pkglist.txt" ] && command -v yay &> /dev/null; then
  run yay -S --needed --noconfirm - < packages/aur-pkglist.txt
fi

echo "=== 4. Installing VS Code Extensions ==="
if [ -f "packages/vscode-extensions.txt" ] && command -v code &> /dev/null; then
  while IFS= read -r extension || [ -n "$extension" ]; do
    if [ -n "$extension" ]; then
      run code --install-extension "$extension" --force
    fi
  done < packages/vscode-extensions.txt
fi

run mkdir -p ~/.ssh && run chmod 700 ~/.ssh

echo "=== 5. Symlinking Dotfiles with GNU Stow ==="
STOW_PKGS=(fastfetch kitty nvim zsh git ssh)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Stow refuses to replace real files. Move any in the way to BACKUP_DIR.
backup_conflicts() {
  local pkg="$1" rel target
  while IFS= read -r rel; do
    target="$HOME/$rel"
    # Skip if missing, a link, or already the repo file (via a linked dir)
    [ -e "$target" ] && [ ! -L "$target" ] || continue
    [ "$(realpath "$target")" = "$(realpath "$pkg/$rel")" ] && continue
    echo "Backing up ~/$rel -> $BACKUP_DIR/$rel"
    run mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    run mv "$target" "$BACKUP_DIR/$rel"
  done < <(cd "$pkg" && find . \( -type f -o -type l \) -printf '%P\n')
}

for pkg in "${STOW_PKGS[@]}"; do
  backup_conflicts "$pkg"
  run stow "$pkg"
done

echo "=== Enabling Git LFS ==="
run git lfs install

echo "=== 6. Setting up Oh My Zsh, Powerlevel10k and Plugins ==="
# Cloned directly instead of using the omz installer, which would overwrite ~/.zshrc
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  echo "Oh My Zsh is already installed."
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "Powerlevel10k is already installed."
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  run git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  run git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "=== 7. Headlessly Syncing Neovim Plugins ==="
if command -v nvim &> /dev/null; then
  run nvim --headless "+Lazy! sync" +qa
fi

echo "=== 8. Restoring GNOME Settings ==="
if command -v dconf &> /dev/null && [ -n "$DISPLAY$WAYLAND_DISPLAY" ]; then
  run dconf load /org/gnome/ < gnome/gnome-settings.ini
else
  echo "Not in a graphical session; run later: dconf load /org/gnome/ < gnome/gnome-settings.ini"
fi

echo "=== 9. Setting zsh as default shell ==="
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  run chsh -s /usr/bin/zsh
fi

echo "=== Setup Complete! ==="
