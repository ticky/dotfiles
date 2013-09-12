autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] )); then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_status() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]; then
    echo ""
  else

    # Output var
    op=""

    # Fetch flag variables
    gle="$(git_local_email)"
    gnp="$(git_need_push)"
    gcb="$(git_current_branch)"

    # Add email if it's there
    if [[ $gle != "" ]]; then
      op="%{$fg[lightgrey]%}$gle%{$reset_color%} "
    fi

    # Append branch info
    op="$op%{$fg[magenta]%}⌥ %{$fg_bold[magenta]%}$gcb%{$reset_color%}"

    # Add modified dot if status isn't "nothing to commit"
    if [[ ! "$st" =~ ^nothing ]]; then
      gf="$gf●"
    fi

    # Add the "needs push" indicator (output of git_need_push)
    if [[ $gnp != "" ]]; then
      gf="$gf$gnp"
    fi

    # Attach "gf" (git flags) to prompt if exists
    if [[ $gf != "" ]]; then
      op="$op %{$fg[magenta]%}$gf%{$reset_color%}"
    fi

    # Output
    echo $op
  fi
}

git_local_email() {
  if [[ $($git config user.email) != $($git config --global user.email) ]]; then
    echo $($git config user.email)
  fi
}

git_current_branch () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

git_need_push () {
  up=$($git cherry -v @{upstream} 2>/dev/null)
  if [[ $up == "" ]]; then
    echo ""
  else
    echo "⬆"
  fi
}

export PROMPT=$'%{$bg_bold[magenta]%}%n@%m%{$reset_color%}%{$fg[magenta]%}:%~\n› %{$reset_color%}'
export RPROMPT=$'$(git_status) %D{%L:%M %p}'
export PS2=$'%{$fg[magenta]%}› %{$reset_color%}'
#set_prompt () {
#}

precmd() {
  title "zsh" "%~ — %n@%m" "%55<...<%~"
#  set_prompt
}