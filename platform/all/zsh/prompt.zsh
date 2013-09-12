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
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]; then
      echo "%{$fg[lightgrey]%}$(git_local_email)%{$fg[magenta]%}⌥ %{$fg_bold[magenta]%}$(git_current_branch)%{$reset_color%} %{$fg[magenta]%}$(git_need_push)%{$reset_color%} "
    else
      echo "%{$fg[lightgrey]%}$(git_local_email)%{$fg[magenta]%}⌥ %{$fg_bold[magenta]%}$(git_current_branch)%{$reset_color%} %{$fg[magenta]%}●$(git_need_push)%{$reset_color%} "
    fi
  fi
}

git_local_email() {
  [[ $(command git config user.email) != $(command git config --global user.email) ]] && echo "`command git config user.email` "
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
export RPROMPT=$'$(git_status)%t'
export PS2=$'%{$fg[magenta]%}› %{$reset_color%}'
#set_prompt () {
#}

precmd() {
  title "zsh" "%~ — %n@%m" "%55<...<%~"
#  set_prompt
}