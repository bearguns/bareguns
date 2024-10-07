eval (/opt/homebrew/bin/brew shellenv)

set -Ua fish_user_paths $HOME/.cargo/bin


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

starship init fish | source
