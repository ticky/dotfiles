path-contains() {
  [[ :$PATH: == *:"$1":* ]]
}

path-append() {
  if ! path-contains "$1"; then
    export PATH="$PATH:$1"
  fi
}

path-prepend() {
  if ! path-contains "$1"; then
    export PATH="$1:$PATH"
  fi
}

# we want the various sbins on the path along with /usr/local/bin
path-append /usr/local/sbin
path-append /usr/sbin
path-append /sbin

# bring in NPM
path-append /usr/local/share/npm/bin

# bring in RVM
path-append "$HOME/.rvm/bin"

# add go support
export GOPATH="$HOME/go"
path-prepend "$GOPATH/bin"

# Prepend all-platform bin directory, platform-based bin directories and all-but-platform directories
for dir in $DOTFILES/platform/all/bin(N) $DOTFILES/platform/$UNAME/bin(N) $DOTFILES/platform/all-but-^$UNAME/bin(N); do
  path-prepend "$dir"
done

# add user bin directory
path-prepend "$HOME/bin"

export PATH
export GOPATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
