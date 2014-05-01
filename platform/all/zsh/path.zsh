# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# bring in NPM
if [[ -d "/usr/local/share/npm/bin" ]]; then
  PATH="$PATH:/usr/local/share/npm/bin"
fi

# Prepend all-platform bin directory, platform-based bin directories, all-but-platform directories and user bin directory to PATH
for dir in ~/dotfiles/platform/all/bin(N) ~/dotfiles/platform/$UNAME/bin(N) ~/dotfiles/platform/all-but-^$UNAME/bin(N) ~/bin(N); do
  PATH="$dir:$PATH"
done

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting