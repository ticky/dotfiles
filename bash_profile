#!/bin/bash
# seaofclouds <http://github.com/seaofclouds/dotfiles>

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}


# ==============================================================================
# SETTINGS
# ==============================================================================

alias dotfiles="mate $HOME/Dotfiles/"

# edit this file
alias settings-edit="mate $HOME/Dotfiles/bash_profile"

alias settings-load="source $HOME/Dotfiles/bash_profile"
alias reload="settings-load"

alias settings-install="ruby $HOME/Dotfiles/install.rb && settings-load"


# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

# fuck that you have new mail shit
unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"

# put ~/.gem on PATH if you have it
test -d "$HOME/.gem" &&
PATH="$HOME/.gem/ruby/1.8/bin:$PATH"

# ----------------------------------------------------------------------
# EDITOR
# ----------------------------------------------------------------------

# use textmate as default editor
test -d "/Applications/TextMate.app" &&
export VISUAL="mate -w"
export EDITOR="mate -w"

alias m="mate "
alias m.="mate ."

alias o="open"
alias o.="open ."

# ----------------------------------------------------------------------
# GIT BRANCH
# ----------------------------------------------------------------------

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1)$(parse_git_dirty)/"
}

# ----------------------------------------------------------------------
# TITLE WINDOW
# ----------------------------------------------------------------------

#set window title
function title() { echo -ne "\033]0;$@\007"; }
function title_git() {
  title `echo ${PWD##*/} "$(parse_git_branch) $@"`
}
title_git

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

WHITEONMAGENTA="\[\033[37;45;1m\]"
MAGENTA="\[\033[0;35m\]"
MAGENTABOLD="\[\033[0;35;1m\]"
WHITEONCYAN="\[\033[37;46;1m\]"

BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
CYAN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
BROWN="\[\033[0;33m\]"
LIGHTGRAY="\[\033[0;37m\]"
DARKGRAY="\[\033[1;30m\]"
LIGHTBLUE="\[\033[1;34m\]"
LIGHTGREEN="\[\033[1;32m\]"
LIGHTCYAN="\[\033[1;36m\]"
LIGHTRED="\[\033[1;31m\]"
LIGHTPURPLE="\[\033[1;35m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"

PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

if [ "$LOGNAME" = "root" ]; then
    COLOR1="${RED}"
    COLOR2="${BROWN}"
    P="#"
else
    COLOR1="${BLUE}"
    COLOR2="${BROWN}"
    P="\$"
fi

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${COLOR1}${P}${PS_CLEAR} "
    PS2="> "
}

# keep working directory to 30 chars, center tuncated
prompt_pwd() {
  local pwd_symbol="..."
  local pwd_length=30
  newPWD="${PWD/#$HOME/~}"
  [ ${#newPWD} -le ${pwd_length} ]
    printf -v newPWD "%-*s" $pwd_length "$newPWD$(parse_git_branch)"
  [ ${#newPWD} -gt ${pwd_length} ] && newPWD=${newPWD:0:10}${pwd_symbol}${newPWD:${#newPWD}-17}
}

prompt_color() {
  PROMPT_COMMAND='prompt_pwd;history -a;title_git'
  PS1="${WHITEONMAGENTA}[\u@\h]${MAGENTA} \w ${MAGENTABOLD}\$${PS_CLEAR} "
  PS1=${PS1//\\w/\$\{newPWD\}}
    PS2="${WHITEONTEAL}>${PS_CLEAR} "
}


# ----------------------------------------------------------------------
# CD, DIRECTORY NAVIGATION
# ----------------------------------------------------------------------

# supress bash_completion pwd on cd
function cd() { 
  command cd "$@" >/dev/null;
}
# go to previous directory
function -() { 
  command cd "-" >/dev/null;
}
# traverse directories
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../../"

# ----------------------------------------------------------------------
# AUTOCOMPLETE
# ----------------------------------------------------------------------

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# autocomplete from these directories
export CDPATH=".:$HOME:$HOME/Sites:$HOME/Sites/heroku"

# ignore case for autocomplete
bind 'set completion-ignore-case On'

# make tab cycle through commands instead of listing 
bind '"\t":menu-complete'

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

# we always pass these to ls(1)
LS_COMMON="-hB"

# if the dircolors utility is available, set that up too
if [ "$TERM" != "dumb" ]; then
    export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dircolors`
fi

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls='ls $LS_OPTIONS $LS_COMMON'

# these use the ls aliases above
alias ll="ls -la"
alias l.="ls -d .*"

# ----------------------------------------------------------------------
# COMMAND HISTORY
# ----------------------------------------------------------------------

# big history
export HISTSIZE=1000

# Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -r; $PROMPT_COMMAND"

#ignore repeat commands
export HISTCONTROL=erasedups

#ignore specific commands
export HISTIGNORE="&:cl:x"

#short history
alias hi='history | tail -20'



# ==============================================================================
# ALIASES / FUNCTIONS
# ==============================================================================

# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
# find
alias fn='find . -name'
# close window
alias x="exit"
# clear window
alias cl="clear"

# ----------------------------------------------------------------------
# SERVERS
# ----------------------------------------------------------------------

# thin start
function ts(){
  title_git " /  Server"
  for ((port=3000; port <= 3010 ; port++)); do
    if thin -p $port start 2>/dev/null; then break; fi
  done
}

# postgresql, psql
alias pgstop="pg_ctl -D `brew --prefix`/var/postgres stop -s -m fast"
alias pgstart="pg_ctl -D `brew --prefix`/var/postgres -l `brew --prefix`/var/postgres/server.log start"

# mongo
alias mstart="title 'MongoDB Server' && `brew --prefix`/bin/mongod --dbpath=$HOME/Sites/_mongodata/"

# ----------------------------------------------------------------------
# RUBY
# ----------------------------------------------------------------------

# gem install
alias sgi32="sudo env ARCHFLAGS=\"-Os -arch i386 -fno-common\" gem install --no-ri --no-rdoc"
alias sgi64="sudo env ARCHFLAGS=\"-Os -arch x86_64 -fno-common\" gem install --no-ri --no-rdoc"
alias sgi="sudo env ARCHFLAGS=\"-Os -arch x86_64 -fno-common\" gem install --no-ri --no-rdoc"

#rake
alias rdm="rake db:migrate"
alias rdfl="rake db:fixtures:load"

# ----------------------------------------------------------------------
# GIT
# ----------------------------------------------------------------------

alias gd="git diff"
alias gu="git up"
alias gs="git status"
alias gf="git fetch"
alias gr="git remote -v"
alias gp="git push"
alias gph="git push heroku master"
alias gps="git push staging staging:master"
alias gpg="git push github master"
alias gpo="git push origin master"
alias gplh="git pull heroku master"
alias gpls="git pull staging staging:master"
alias gplg="git pull github master"
alias gplo="git pull origin master"
alias gpl="git pull"
alias gc="git commit -am"
alias ga="git add ."

# ----------------------------------------------------------------------
# PROJECTS
# ----------------------------------------------------------------------

alias s="cd $HOME/Sites/"
alias cdtmb="cd $HOME/Library/Application\ Support/TextMate/Bundles/"

# heroku
alias h="cd ~/Sites/heroku"
alias navrestart='for i in "business" "news" "success" "legal" "logos" "about" "public" "blog" "docs"; do heroku restart --app $i && sleep 1; done'



# ==============================================================================
# USER SHELL ENVIRONMENT
# ==============================================================================

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_color
