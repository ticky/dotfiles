autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

export PROMPT_PRIMARY=magenta
export PROMPT_SECONDARY=lightgrey

if (( $+commands[git] )); then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

prompt_git_status() {
  if [[ ! -e "$PWD/.git" ]]; then
    return
  fi

  if ! breakpt md-up; then
    return
  fi

  # Output var
  git_output=""
  git_flags=""

  # Fetch flag variables
  local_email="$(prompt_git_local_email)"
  needs_push="$(prompt_git_need_push)"
  current_branch="$(prompt_git_current_branch)"

  # Add email if it's there
  if [[ $local_email != "" ]]; then
    git_output="$local_email "
  fi

  # Append branch info
  git_output="$git_output%{$fg[$PROMPT_PRIMARY]%}⌥ %{$fg_bold[$PROMPT_PRIMARY]%}$current_branch%{$reset_color%}"

  git_status=$($git status --porcelain 2>/dev/null)
  # Add modified dot if status isn't empty
  if [[ "$git_status" != "" ]]; then
    git_flags="$git_flags●"
  fi

  # Add the "needs push" indicator
  if [[ $needs_push != "" ]]; then
    git_flags="$git_flags$needs_push"
  fi

  # Attach flags to prompt if exists
  if [[ $git_flags != "" ]]; then
    git_output="$git_output %{$fg[$PROMPT_PRIMARY]%}$git_flags%{$reset_color%}"
  fi

  # Output
  echo "$git_output"
}

prompt_git_local_email() {
  local_email="$($git config user.email)"
  if [[ $local_email != $($git config --global user.email) ]]; then
    if breakpt md-up; then
      echo $local_email
    else
      echo "@"
    fi
  fi
}

prompt_git_current_branch() {
  ref=$($git symbolic-ref --quiet --short HEAD 2>/dev/null) || ref=$($git show-ref --head --hash --abbrev | head -n1 2>/dev/null) || return
  echo "$ref"
}

prompt_git_need_push() {
  up=$($git cherry -v @{upstream} 2>/dev/null)
  if [[ $up == "" ]]; then
    return
  else
    echo "⬆"
  fi
}

prompt_userhost() {
  if [[ -n "$TMUX" || -n "$STY" ]]; then
    # Inside tmux or GNU screen, just show username
    echo -n "%n"
  else
    # If we're not inside tmux or GNU screen
    if breakpt xs; then
      # If the terminal is small, just show the host
      echo -n "%m"
    else
      # If the terminal is not small, show user and host
      echo -n "%n@%m"
    fi
  fi
}

prompt_cwd() {
  if breakpt xl; then
    # Show fully-qualified cwd
    echo -n "%d"
  else
    if breakpt xs; then
      # Show only current directory name
      echo -n "%1d"
    else
      # Show directory relative to ~
      echo -n "%~"
    fi
  fi
}

prompt_clock() {
  LONG_FORMAT=l
  MEDIUM_FORMAT=m
  SHORT_FORMAT=s

  if breakpt md-up; then
    echo -n "%{$reset_color%} "
  fi

  if [[ "$(TZ=Etc/GMT-1 zdate %m-%d)" == "04-01" ]]; then
    LONG_FORMAT="%a %b %f @%i"
    MEDIUM_FORMAT="%a @%i"
    SHORT_FORMAT="@%i"
  fi

  if breakpt xl; then
    zdate $LONG_FORMAT
  elif breakpt lg-up; then
    zdate $MEDIUM_FORMAT
  elif breakpt md-up; then
    zdate $SHORT_FORMAT
  fi
}

export PROMPT=$'%{$bg_bold[$PROMPT_PRIMARY]%}$(prompt_userhost)%{$reset_color%}:%{$fg[$PROMPT_PRIMARY]%}$(prompt_cwd)\n› %{$reset_color%}'
export RPROMPT=$' $(prompt_git_status)$(prompt_clock)'
export PROMPT2=$'› '

if [[ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then

  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

  # Default Formatting
  ZSH_HIGHLIGHT_STYLES[default]="none"

  # Commands
  ZSH_HIGHLIGHT_STYLES[alias]="none"
  ZSH_HIGHLIGHT_STYLES[builtin]="none"
  ZSH_HIGHLIGHT_STYLES[function]="none"
  ZSH_HIGHLIGHT_STYLES[command]="none"
  ZSH_HIGHLIGHT_STYLES[hashed-command]="none"

  # Command Prefix (sudo, buitin, etc.)
  ZSH_HIGHLIGHT_STYLES[precommand]="fg=yellow,bold"

  # Missing
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red,bold"
  ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=red"

  # Command Separators (;, ||, &&, etc.)
  ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=green"

  # Globbing and Paths
  ZSH_HIGHLIGHT_STYLES[path]="underline"
  ZSH_HIGHLIGHT_STYLES[path_prefix]="underline"
  ZSH_HIGHLIGHT_STYLES[path_approx]="fg=yellow,underline"
  ZSH_HIGHLIGHT_STYLES[globbing]="fg=blue,bold"

  # History Expansion Characters (!, ^, #)
  ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=blue"

  # Options
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=blue"
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=blue"

  # Strings and quoted arguments
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="none"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=green"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=green"
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=cyan"
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=cyan"

  # Variable Assignments
  ZSH_HIGHLIGHT_STYLES[assign]="none"

  # Mismatched brackets
  ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=red,standout"
  ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]="standout"

fi

precmd() {
  title "zsh" "%~ — %n@%m" "%55<...<%~"
}
