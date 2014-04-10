# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# bring in NPM
if [[ -d "/usr/local/share/npm/bin" ]]; then
  PATH="$PATH:/usr/local/share/npm/bin"
fi

# All-OS user bin
if [[ -d "$HOME/dotfiles/platform/all/bin" ]]; then
  PATH="$HOME/dotfiles/platform/all/bin:$PATH"
fi

# Allow platform-based overrides
if [[ -d "$HOME/dotfiles/platform/$UNAME/bin" ]]; then
  PATH="$HOME/dotfiles/platform/$UNAME/bin:$PATH"
fi

# Allow platform-based overrides
if [[ -d "$HOME/dotfiles/platform/all-but-!($UNAME)/bin" ]]; then
  PATH="$HOME/dotfiles/platform/all-but-!($UNAME)/bin:$PATH"
fi

# put ~/bin on PATH if you have it
if [[ -d "$HOME/bin" ]]; then
  PATH="$HOME/bin:$PATH"
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting