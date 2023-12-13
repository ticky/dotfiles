path-contains() {
  [[ :$PATH: == *:"$1":* ]]
}

path-append() {
  export PATH="${PATH/:$1:/:}:$1"
}

path-prepend() {
  export PATH="$1:${PATH/:$1:/:}"
}

# prepend /usr/local/bin in case we're on Tiger
path-prepend /usr/local/bin

# we want the various sbins on the path along with /usr/local/bin
path-append /usr/local/sbin
path-append /usr/sbin
path-append /sbin

# Handle multiple Homebrews on Apple Silicon
if [[ "$(/usr/sbin/sysctl -n hw.optional.arm64 2> /dev/null)" == "1" ]]; then
  path-prepend /opt/homebrew/bin
fi

# bring in NPM
path-append /usr/local/share/npm/bin

# bring in Rust
path-append "$HOME/.cargo/bin"

# bring in RVM
path-append "$HOME/.rvm/bin"

# add go support
export GOPATH="$HOME/go"
path-prepend "$GOPATH/bin"

# add mono support
if [[ -d "/Library/Frameworks/Mono.framework/Versions/Current/Commands" ]]; then
  path-append "/Library/Frameworks/Mono.framework/Versions/Current/Commands"
fi

path-prepend "/opt/homebrew/opt/dotnet@6/bin"

# Prepend all-platform bin directory, platform-based bin directories and all-but-platform directories
for dir in $DOTFILES/platform/all/bin(N) $DOTFILES/platform/$UNAME/bin(N) $DOTFILES/platform/all-but-^$UNAME/bin(N); do
  path-prepend "$dir"
done

# add user bin directory
path-prepend "$HOME/bin"

export PATH
export GOPATH
