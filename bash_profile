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
alias settings-edit="mate $HOME/.bash_profile"

alias settings-load="source $HOME/.bash_profile"
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

# mate shortcut
function m() { 
  command mate "$@" >/dev/null;
}
alias m.="m ."

# open shortcut
function o() { 
  command open "$@" >/dev/null;
}
alias o.="o ."

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
function title() { 
  echo -ne "\033]0;$@\007"; 
}
function title_git() {
  title `echo ${PWD##*/} "$(parse_git_branch) $@"`
}

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

WHITEONMAGENTA="\[\033[37;45;1m\]"
MAGENTA="\[\033[0;35m\]"
MAGENTABOLD="\[\033[0;35;1m\]"

WHITEONCYAN="\[\033[37;46;1m\]"
CYAN="\[\033[0;36m\]"
CYANBOLD="\[\033[0;36;1m\]"

PURPLE="\[\033[0;35m\]"

PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

if [ `/usr/bin/whoami` = "root" ] ; then
  COLOR_BACKGROUND="${WHITEONCYAN}"
  COLOR_REGULAR="${CYAN}"
  COLOR_BOLD="${CYANBOLD}"
else
  COLOR_BACKGROUND="${WHITEONMAGENTA}"
  COLOR_REGULAR="${MAGENTA}"
  COLOR_BOLD="${MAGENTABOLD}"
fi

function prompt_pwd() {
  #replace "/home/username with ~"
  #newPWD="${PWD/#$HOME/~}"
  newPWD="${PWD} $(parse_git_branch)"
}

function prompt_color() {
  PROMPT_COMMAND='prompt_pwd;history -a;title_git'
  PS1="${COLOR_BACKGROUND}\u@\h${COLOR_REGULAR}:\w\n${COLOR_BOLD}\$${PS_CLEAR} "
  PS1=${PS1//\\w/\$\{newPWD\}}
    PS2="${PURPLE}>${PS_CLEAR} "
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
alias ...="cd ../.."
alias ....="cd ../../../"

# create a directory and cd into it
function mkcd () { 
  mkdir -p "$@" && eval cd "\"\$$#\""; 
}


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

# always pass these options to ls(1)
LS_COMMON="-hB"

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls='ls $LS_OPTIONS $LS_COMMON'

# list all files in directory
alias ll="ls -la"

# list dot files in directory
alias l.="ls -d .*"

# if the dircolors utility is available, set that up too
if [ "$TERM" != "dumb" ]; then
    export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dircolors`
fi

# ----------------------------------------------------------------------
# COMMAND HISTORY
# ----------------------------------------------------------------------

# big history
export HISTSIZE=1000

# format history with timestamp
# 319  | 2010-06-02 09:02PM | reload
export HISTTIMEFORMAT="| %F %I:%M%p | "

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -r; $PROMPT_COMMAND"

# ignore repeat commands
export HISTCONTROL=erasedups

# ignore specific commands
export HISTIGNORE="&:cl:x"

# speedy history
# usage:  $ hi 4 ; will list last 4 commands
# or:     $ hi keyword ; will grep history for keyword
function hi(){
  if [[ $1 =~ ^[0-9]+$ ]]; then
    command history | tail -n "$1";
  elif [ "$1" != "" ]; then
    command history | grep "$1";
  else
    command history | tail -20;
  fi
}


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
# PNGCRUSH, crush images in a directory
# ----------------------------------------------------------------------

# usage:  $ cd dir_with_images && png dir_to_save_new_images
# or:     $ cd dir_with_images && png ; will save images to ../crushedimages
function png(){
  if [ "$1" != "" ]; then
    command pngcrush -d "../$1" *.png;
  else
    command pngcrush -d "../crushedimages" *.png;
  fi
}
# ----------------------------------------------------------------------
# SERVERS
# ----------------------------------------------------------------------

# thin start
# usage:  $ ts ; will start server on first available 300x port
# or:     $ ts 3001 ; will start server on port 3001
function ts(){
  title_git " /  Server"
  if [ "$1" != "" ]; then
    command thin -p "$1" start;
  else
    for ((port=3000; port <= 3010 ; port++)); do
      if thin -p $port start 2>/dev/null; then break; fi
    done
  fi
}

# postgresql, psql
alias pgx="pg_ctl -D `brew --prefix`/var/postgres stop -s -m fast"
alias pgs="pg_ctl -D `brew --prefix`/var/postgres -l `brew --prefix`/var/postgres/server.log start"

# mongo
alias ms="title 'MongoDB Server' && `brew --prefix`/bin/mongod --dbpath=$HOME/Sites/_mongodata/"

# ----------------------------------------------------------------------
# RUBY
# ----------------------------------------------------------------------

# gem install
alias sgi32="sudo env ARCHFLAGS=\"-Os -arch i386 -fno-common\" gem install --no-ri --no-rdoc"
alias sgi64="sudo env ARCHFLAGS=\"-Os -arch x86_64 -fno-common\" gem install --no-ri --no-rdoc"
alias sgi="sudo env ARCHFLAGS=\"-Os -arch x86_64 -fno-common\" gem install --no-ri --no-rdoc"

# rake tasks
alias rdm="rake db:migrate"
alias rdfl="rake db:fixtures:load"

# ----------------------------------------------------------------------
# GIT
# ----------------------------------------------------------------------

alias gd="git diff"
alias gl="git log"
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

title_git

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_color
