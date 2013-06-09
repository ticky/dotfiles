#!/usr/bin/env bash

# kernel name
: ${UNAME=$(uname | tr '[A-Z]' '[a-z]')}

# working around Cygwin weirdness
# NOTE: On Linux and Darwin (and likely FreeBSD), `uname` returns the kernel name.
#       On Cygwin, you get a long string including CYGWIN, kernel version and architecture.
#       We override Cygwin's entry for brevity here.
`uname -o > /dev/null 2> /dev/null` && if [ `uname -o` = "Cygwin" ]; then
  UNAME="cygwin"
fi

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
git --version >/dev/null 2>&1 || missingdep git
# SSH
ssh -V >/dev/null 2>&1 || missingdep SSH

# Check for Bash 3.2 or newer
eval $(bash --version | sed -e '/^[^G]/d' -e "s/.* \([0-9]\)\.\([0-9]\).*/BASHMAJ=\1;BASHMIN=\2/")
if [ $BASHMAJ -lt 3 -o $BASHMAJ -ge 3 -a $BASHMIN -lt 2 ]; then
  missingdep "Bash 3.2 (or newer)"
fi

# On Cygwin, check for the `clear` command (because it sucks when it's missing)
if [ "$UNAME" = "cygwin" ]; then
  clear >/dev/null 2>&1 || missingdep "ncurses"
fi

# On OS X, check for Homebrew
if [ "$UNAME" = "darwin" ]; then
  brew --version >/dev/null 2>&1 || missingdep "Homebrew"
fi

if [ "$MISSINGDEPS" == "YES" ]; then
  echo -e $MISSINGLIST
  echo
  echo "Installation aborted."
  exit 1
else
  echo "Dependencies satisfied."
  echo
  echo "## Installing files..."

  for file in ~/dotfiles/*
  do
    basename=$(basename $file)
    target=~/.$basename
    if [ "${basename}" == "install.sh" -o "${basename}" == "readme.md" -o "${basename}" == "bin" ]
    then
      continue
    fi
    echo "* Installing \"$basename\" to \"$target\""
    if [ "$UNAME" = "cygwin" ]
    then
      ln -f $file $target
    else
      ln -sf $file $target
    fi
  done

  echo "Installation complete. Please restart your shell."
  exit 0
fi