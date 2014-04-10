#!/usr/bin/env bash

# make sure extended and null globbing are on
shopt -s extglob
shopt -s nullglob

# kernel name
UNAME="$(~/dotfiles/platform/all/bin/nuname)"

echo "# Geoff's Dotfiles"
echo "https://github.com/geoffstokes/dotfiles"
echo "Setting up for platform \"$UNAME\""
echo

echo "## Checking for missing dependencies..."
MISSINGDEPS="NO"
MISSINGLIST="Missing Depdnencies:"

function missingdep {
  MISSINGDEPS="YES"
  MISSINGLIST="$MISSINGLIST\n* $1"
}

# git
if ! command -v git >/dev/null 2>&1; then
  missingdep Git
fi
# Python
if ! command -v python >/dev/null 2>&1; then
  missingdep "Python 2.6/2.7"
fi
# SSH
if ! command -v ssh >/dev/null 2>&1; then
  missingdep SSH
fi
# ncurses
if ! command -v clear >/dev/null 2>&1; then
  missingdep "ncurses"
fi

# Check for Bash 3.2 or newer
eval "$($(which bash) --version | sed -e '/^[^G]/d' -e "s/.* \([0-9]\)\.\([0-9]\).*/BASHMAJ=\1;BASHMIN=\2/")"
if [[ $BASHMAJ -le 3 && $BASHMIN -lt 2 ]]; then
  missingdep "Bash 3.2 (or newer)"
fi

# Check for zsh 4.3 or newer
eval "$($(which zsh) --version | sed -e "s/.* \([0-9]\)\.\([0-9]\).*/ZSHMAJ=\1;ZSHMIN=\2/")"
if [[ $ZSHMAJ -le 4 && $ZSHMIN -lt 3 ]]; then
  missingdep "zsh 4.3 (or newer)"
fi

# Check for IPv6 capable Perl Regexp::Common
if ! $(which perl) -MRegexp::Common -e 'print $RE{net}{IPv6}' >/dev/null 2>&1; then
  missingdep "Regexp::Common 2013031301 or newer"
fi

# On Cygwin, check for the `clear` command (because it sucks when it's missing)
if [[ "$UNAME" = "cygwin" ]]; then

  if ! command -v clear >/dev/null 2>&1; then
    missingdep "ncurses"
  fi

  if [[ ! -r $(cygpath -u "$WINDIR/Fonts/DejaVuSansMono.ttf") ]]; then
    missingdep "DejaVu Sans Mono"
    explorer http://dejavu-fonts.org/wiki/Download
  fi

fi

# On OS X, check for Homebrew and reattach-to-user-namespace
if [[ "$UNAME" = "darwin" ]]; then

  if ! command -v brew >/dev/null 2>&1; then
    missingdep "Homebrew"
  fi

  if ! command -v reattach-to-user-namespace >/dev/null 2>&1; then
    missingdep "reattach-to-user-namespace"
  fi

fi

if [[ "$MISSINGDEPS" == "YES" ]]; then

  echo -e "$MISSINGLIST"
  echo
  echo "Installation aborted."
  exit 1

else

  echo "Dependencies satisfied."
  echo
  echo "## Installing files..."

  echo
  echo "### Installing symlinks..."

  for file in ~/dotfiles/platform/all/home/*.symlink ~/dotfiles/platform/$UNAME/home/*.symlink ~/dotfiles/platform/all-but-!($UNAME)/home/*.symlink; do

    basename=$(basename "$file")
    target=~/.${basename%.symlink}

    if [[ -r "$file" ]]; then

      echo "* Linking \"$basename\" as \"$target\""

      if [[ "$UNAME" = "cygwin" ]]; then
        ln -f "$file" "$target"
      else
        ln -sf "$file" "$target"
      fi

    fi

  done

  echo
  echo "### Concatenating files..."

  for file in ~/dotfiles/platform/all/home/*.concat ~/dotfiles/platform/$UNAME/home/*.concat ~/dotfiles/platform/all-but-!($UNAME)/home/*.concat; do

    basename=$(basename "$file")
    target=~/.${basename%.concat}

    if [[ -r "$file" ]]; then

      if [[ -r "$target" ]]; then
        echo "* Moving existing \"$target\" to \"$target.bak\""
        mv "$target" "$target.bak"
      fi

    fi

  done

  for file in ~/dotfiles/platform/all/home/*.concat ~/dotfiles/platform/$UNAME/home/*.concat ~/dotfiles/platform/all-but-!($UNAME)/home/*.concat; do

    basename=$(basename "$file")
    target=~/.${basename%.concat}

    if [[ -r "$file" ]]; then

      echo "* Creating \"$target\" from \"$basename\""

      if [[ -d "$file" ]]; then
        cp -R "$file" "$target"
      else
        cat "$file" >> "$target"
      fi

    fi

  done

  echo "Installation complete. Please restart your shell."
  exit 0

fi
