# Aliases. Sourced from ~/.zshrc.

# eza: better ls
if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --git --group-directories-first --icons=auto'
  alias la='eza -la --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'
fi

# bat: better cat
if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Editor
alias v='nvim'
alias vim='nvim'

# Quick edits
alias zshrc='nvim ~/.zshrc'
alias reload='exec zsh'
alias dots='cd ~/dotfiles'

# Arch
alias update='yay -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
