# Handle multiple Homebrews on Apple Silicon
if [[ "$(/usr/sbin/sysctl -n hw.optional.arm64 2> /dev/null)" == "1" ]]; then
  alias ibrew='HOMEBREW_LOGS="${HOME}/Library/Logs/Homebrew (Intel)" arch -x86_64 /usr/local/bin/brew'
fi

# Virtualenv Wrapper (Python)
if [[ -s "/usr/local/bin/virtualenvwrapper.sh" ]]; then
  export WORKON_HOME="$HOME/.virtualenv"
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

# NVM (node.js)
NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  export NVM_DIR
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
