#!/usr/bin/env bash

# make sure extended and null globbing are on
shopt -s extglob
shopt -s nullglob

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
if [ $BASHMAJ -lt 3 -o $BASHMAJ -eq 3 -a $BASHMIN -lt 2 ]; then
  missingdep "Bash 3.2 (or newer)"
fi

# On Cygwin, check for the `clear` command (because it sucks when it's missing)
if [ "$UNAME" = "cygwin" ]; then
  clear >/dev/null 2>&1 || missingdep "ncurses"
  if [ ! -r `cygpath -u $WINDIR/Fonts/DejaVuSansMono.ttf` ]; then
    missingdep "DejaVu Sans Mono"
    explorer http://dejavu-fonts.org/wiki/Download
  fi
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

  echo
  echo "### Installing symlinks..."

  for file in ~/dotfiles/platform/all/home/*.symlink ~/dotfiles/platform/$UNAME/home/*.symlink ~/dotfiles/platform/all-but-!($UNAME)/home/*.symlink
  do
    basename=$(basename $file)
    target=~/.${basename%.symlink}
    if [ -r $file ]; then
      echo "* Linking \"$basename\" as \"$target\""
      if [ "$UNAME" = "cygwin" ]; then
        ln -f $file $target
      else
        ln -sf $file $target
      fi
    fi
  done

  echo
  echo "### Concatenating files..."

  for file in ~/dotfiles/platform/all/home/*.concat ~/dotfiles/platform/$UNAME/home/*.concat ~/dotfiles/platform/all-but-!($UNAME)/home/*.concat
  do
    basename=$(basename $file)
    target=~/.${basename%.concat}
    if [ -r $file ]; then
      if [ -r $target ]; then
        echo "* Moving existing \"$target\" to \"$target.bak\""
        mv $target "$target.bak"
      fi
    fi
  done

  for file in ~/dotfiles/platform/all/home/*.concat ~/dotfiles/platform/$UNAME/home/*.concat ~/dotfiles/platform/all-but-!($UNAME)/home/*.concat
  do
    basename=$(basename $file)
    target=~/.${basename%.concat}
    if [ -r $file ]; then
      echo "* Creating \"$target\" from \"$basename\""
      if [ -d $file ]; then
        cp -R $file $target
      else
        cat $file >> $target
      fi
    fi
  done

  echo "Installation complete. Please restart your shell."
  exit 0
fi