#!/bin/sh
# Bootstrap dotfiles on a fresh machine (macOS or Linux).
#   DOTFILES_REPO=<url>  override the clone URL
#   ASSUME_YES=1         skip the SSH-key prompt (no terminal needed)
#   SKIP_INSTALL=1       skip the mise/starship installers
set -eu

DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:bearguns/bareguns.git}"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

dot() { git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"; }
say() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# 0. Gate: the clone needs a GitHub SSH key.
if [ "${ASSUME_YES:-}" != 1 ]; then
  ( : </dev/tty ) 2>/dev/null || die "no terminal to ask on; set ASSUME_YES=1 to skip the prompt"
  printf 'Have you set up your GitHub SSH key on this machine? [y/N] ' >/dev/tty
  read -r answer </dev/tty || answer=n
  case $answer in
    y | Y | yes | YES | Yes) ;;
    *)
      cat <<'EOF'
Set one up first, then re-run:
  ssh-keygen -t ed25519 -C "you@example.com"
  cat ~/.ssh/id_ed25519.pub   # add at https://github.com/settings/keys
EOF
      exit 0
      ;;
  esac
fi

# 1. Preflight.
command -v git >/dev/null 2>&1 || die "git is required"
command -v curl >/dev/null 2>&1 || die "curl is required"

case $DOTFILES_REPO in
  git@github.com:*)
    say "Checking GitHub SSH access"
    ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 |
      grep -q 'successfully authenticated' ||
      die "GitHub SSH auth failed; check 'ssh -T git@github.com'"
    ;;
esac

# 2. Clone.
if [ -d "$DOTFILES_DIR" ]; then
  say "$DOTFILES_DIR already exists, skipping clone"
else
  say "Cloning $DOTFILES_REPO"
  git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi
dot config status.showUntrackedFiles no

# 3. Checkout, moving anything in the way into $BACKUP_DIR.
if ! dot checkout >/dev/null 2>&1; then
  say "Backing up conflicting files to $BACKUP_DIR"
  tab=$(printf '\t')
  dot checkout 2>&1 | sed -n "s/^$tab//p" | while IFS= read -r f; do
    mkdir -p "$BACKUP_DIR/$(dirname "$f")"
    mv "$HOME/$f" "$BACKUP_DIR/$f"
  done
  dot checkout
fi

# 4. The bare repo's exclude file isn't cloned; copy the tracked one in.
mkdir -p "$DOTFILES_DIR/info"
cp "$HOME/.config/dotfiles/exclude" "$DOTFILES_DIR/info/exclude"

# 5. mise and starship, both into ~/.local/bin.
if [ "${SKIP_INSTALL:-}" != 1 ]; then
  mkdir -p "$HOME/.local/bin"
  if [ ! -x "$HOME/.local/bin/mise" ] && ! command -v mise >/dev/null 2>&1; then
    say "Installing mise"
    curl -fsSL https://mise.run | sh
  fi
  if [ ! -x "$HOME/.local/bin/starship" ] && ! command -v starship >/dev/null 2>&1; then
    say "Installing starship"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
  fi
fi

# 6. fish itself comes from the OS package manager.
if ! command -v fish >/dev/null 2>&1; then
  case $(uname) in
    Darwin) say "fish missing: brew bundle --file=~/.config/homebrew/Brewfile" ;;
    *) say "fish missing: install it with your package manager" ;;
  esac
fi

cat <<'EOF'

Done. Next:
  1. Create ~/.config/fish/secrets.fish with your tokens (untracked).
  2. mise install
  3. chsh -s "$(command -v fish)"   # then open a new terminal
EOF
