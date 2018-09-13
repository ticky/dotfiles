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
  export AUTO_NTFY_DONE_IGNORE="buildkite-agent"
  eval "$(ntfy shell-integration)"
fi
