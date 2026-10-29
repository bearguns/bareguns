# brew on mac systems
switch (uname)
    case Darwin
        eval (/opt/homebrew/bin/brew shellenv)
end

fish_add_path -g $HOME/.cargo/bin

alias dot="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path -g $BUN_INSTALL/bin

command -q starship; and starship init fish | source

# mise
test -x ~/.local/bin/mise; and ~/.local/bin/mise activate fish | source

