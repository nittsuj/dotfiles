# User-local toolchain (Node from ~/.local/node); added by cipher-safe setup.
export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/bin/env"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git ssh-agent)

zstyle ':omz:plugins:ssh-agent' identities id_ed25519

source $ZSH/oh-my-zsh.sh
