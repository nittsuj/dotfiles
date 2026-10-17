# User-local toolchain (Node from ~/.local/node); added by cipher-safe setup.
export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/bin/env"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Initialize Starship Prompt
eval "$(starship init zsh)"

plugins=(git ssh-agent)

zstyle ':omz:plugins:ssh-agent' identities id_ed25519

source $ZSH/oh-my-zsh.sh

# Aliases
alias ls='ls --color=auto'
alias la='ls -la'
alias dot='cd ~/dotfiles'
alias update='sudo pacman -Syu && yay -Sua'
