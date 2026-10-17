eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# User-local toolchain (Node from ~/.local/node); added by cipher-safe setup.
export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/bin/env"
