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

# nodenv (node.js)
if which nodenv >/dev/null 2>&1; then
  eval "$(nodenv init -)"
fi

# coloursum
if which coloursum >/dev/null 2>&1; then
  eval "$(coloursum --mode=1password shell-setup)"
fi

# rbenv or chruby or RVM (Ruby)
if which rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
elif [[ -s "/usr/local/share/chruby/chruby.sh" ]]; then
  # Load chruby
  source "/usr/local/share/chruby/chruby.sh"
elif [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  # Load RVM into a shell session *as a function*
  source "$HOME/.rvm/scripts/rvm"
fi

# iTerm 2 shell integration
if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# ntfy (https://ntfy.readthedocs.io/en/latest/)
if which ntfy >/dev/null 2>&1; then
  eval "$(ntfy shell-integration)"
  export AUTO_NTFY_DONE_IGNORE="$AUTO_NTFY_DONE_IGNORE buildkite-agent"
fi

# Secretive (https://github.com/maxgoedjen/secretive)
if [[ -S "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]]; then
  export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
fi
