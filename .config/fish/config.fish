eval (/opt/homebrew/bin/brew shellenv)

set -Ua fish_user_paths $HOME/.cargo/bin


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

starship init fish | source


set -Ua PATH $PATH

# pnpm
set -gx PNPM_HOME "/Users/smb/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# mise
/Users/smb/.local/bin/mise activate fish | source
