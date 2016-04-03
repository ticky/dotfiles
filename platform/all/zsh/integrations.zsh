# Virtualenv Wrapper (Python)
if [[ -s "/usr/local/bin/virtualenvwrapper.sh" ]]; then
  export WORKON_HOME="$HOME/.virtualenv"
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

# NVM (node.js)
if [[ -d "$HOME/.nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
fi

# chruby or RVM (Ruby)
if [[ -s "/usr/local/share/chruby/chruby.sh" ]]; then
  # Load chruby
  source "/usr/local/share/chruby/chruby.sh"
elif [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  # Load RVM into a shell session *as a function*
  source "$HOME/.rvm/scripts/rvm"
fi
