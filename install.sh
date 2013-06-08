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

echo "Geoff's Dotfiles"
echo "================"
echo "https://github.com/geoffstokes/dotfiles"
echo "Setting up for platform \"$UNAME\""
echo

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

echo
echo "Installation complete."