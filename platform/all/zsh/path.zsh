# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# bring in NPM
test -d "/usr/local/share/npm/bin" &&
PATH="$PATH:/usr/local/share/npm/bin"

# All-OS user bin
test -d "$HOME/dotfiles/platform/all/bin" &&
PATH="$HOME/dotfiles/platform/all/bin:$PATH"

# Allow platform-based overrides
test -d "$HOME/dotfiles/platform/$UNAME/bin" &&
PATH="$HOME/dotfiles/platform/$UNAME/bin:$PATH"

# Allow platform-based overrides
test -d "$HOME/dotfiles/platform/all-but-!($UNAME)/bin" &&
PATH="$HOME/dotfiles/platform/all-but-!($UNAME)/bin:$PATH"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting