#!/usr/bin/env bash

# get dotfiles directory
DOTFILES="$HOME/.dotfiles"

# kernel name
UNAME="$($DOTFILES/platform/all/bin/nuname)"

# banner
echo "# Jessica's Dotfiles"
echo "https://github.com/ticky/dotfiles"
echo

# platform check
if [[ -z "$UNAME" ]]; then
  echo "Unable to determine platform." >&2
  echo >&2
  echo "Installation aborted." >&2
  exit 1
fi

echo "## Checking for missing dependencies for platform \"$UNAME\"..."
MISSINGDEPS="NO"
MISSINGLIST="Missing Depdnencies:"

missingdep() {
  MISSINGDEPS="YES"
  MISSINGLIST="$MISSINGLIST\n* $1"
}

# git
if ! command -v git >/dev/null 2>&1; then
  missingdep Git
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
eval "$($(command -v bash) --version | sed -e '/^[^G]/d' -e "s/.* \([0-9]*\)\.\([0-9]*\).*/BASHMAJ=\1;BASHMIN=\2/")"
if [[ $BASHMAJ -le 3 && $BASHMIN -lt 2 ]]; then
  missingdep "Bash 3.2 (or newer)"
fi

# Check for zsh 4.3 or newer
eval "$($(command -v zsh) --version | sed -e "s/.* \([0-9]*\)\.\([0-9]*\).*/ZSHMAJ=\1;ZSHMIN=\2/")"
if [[ $ZSHMAJ -le 4 && $ZSHMIN -lt 3 ]]; then
  missingdep "zsh 4.3 (or newer)"
fi

# Check for IPv6 capable Perl Regexp::Common
if ! $(command -v perl) -MRegexp::Common -e 'print $RE{net}{IPv6}' >/dev/null 2>&1; then
  missingdep "Regexp::Common 2013031301 or newer"
fi

# On Cygwin, check for the `clear` command (because it sucks when it's missing)
if [[ "$UNAME" = "cygwin" ]]; then

  if [[ ! -r $(cygpath -u "$WINDIR/Fonts/DejaVuSansMono.ttf") ]]; then
    missingdep "DejaVu Sans Mono"
    explorer http://dejavu-fonts.org/wiki/Download
  fi

fi

# On macOS, check for Homebrew and reattach-to-user-namespace
if [[ "$UNAME" = "darwin" ]]; then

  if ! command -v brew >/dev/null 2>&1; then
    missingdep "Homebrew"
  fi

  if ! command -v reattach-to-user-namespace >/dev/null 2>&1; then
    missingdep "reattach-to-user-namespace"
  fi

fi

if [[ "$MISSINGDEPS" == "YES" ]]; then

  echo -e "$MISSINGLIST" >&2
  echo >&2
  echo "Installation aborted." >&2
  exit 1

else

  echo "Dependencies satisfied!"
  echo
  "$HOME/.dotfiles/script/setup" --quiet

fi
