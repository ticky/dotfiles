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

function profile() { 
  if [ "$1" = "edit" ]; then
    command cd $HOME/Dotfiles && command mvim -p .;
  elif [ "$1" = "vim" ]; then
    command mvim -p $HOME/Dotfiles/vimrc \
      $HOME/Dotfiles/vim/colors/sea_dark.vim
  elif [ "$1" = "load" ]; then
    command source $HOME/.bashrc;
  elif [ "$1" = "install" ]; then
    command cd $HOME/Dotfiles/ && ruby $HOME/Dotfiles/install.rb && \
      profile load;
  else
    echo "AVAILABLE COMMANDS: edit, load, install"
  fi
}
alias p="profile"

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

# put ~/dotfiles/bin on PATH if you have it
test -d "$HOME/dotfiles/bin" &&
PATH="$HOME/dotfiles/bin:$PATH"

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"

# put ~/.gem on PATH if you have it
test -d "$HOME/.gem" &&
PATH="$HOME/.gem/ruby/1.8/bin:$PATH"

# ----------------------------------------------------------------------
# EDITOR
# ----------------------------------------------------------------------

export EDITOR="mvim"

# vim edit shortcut
function e() { 
  command mvim -p "$@" >/dev/null;
}
alias e.="e ."
alias vi="mvim -p"
alias v="vi"
alias v.="vi ."

# open shortcut
function o() { 
  command open "$@" >/dev/null;
}
alias o.="o ."

# ----------------------------------------------------------------------
# GIT BRANCH
# ----------------------------------------------------------------------

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working
  directory clean)" ]] && echo " [+]"
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

# 2 LINE PROMPT

function prompt_pwd() {
  #replace "/home/username with ~"
  #newPWD="${PWD/#$HOME/~}"
  newPWD="${PWD} $(parse_git_branch)"
}
function prompt_color() {
  PROMPT_COMMAND='prompt_pwd;history -a;title_git'
  PS1="${COLOR_BACKGROUND}\u@\h${COLOR_REGULAR}:\w\n${COLOR_BOLD}>${PS_CLEAR} "
  PS1=${PS1//\\w/\$\{newPWD\}}
    PS2="${PURPLE}>${PS_CLEAR} "
}

# TRUNCATED PROMPT
#
# prompt_pwd() {
#   local pwd_symbol=".."
#   local pwd_length=30
#   newPWD="${PWD/#$HOME/~}"
#   [ ${#newPWD} -gt ${pwd_length} ] && newPWD=${newPWD:0:12}${pwd_symbol}${newPWD:${#newPWD}-15}
# }
# prompt_color() {
#   PROMPT_COMMAND='prompt_pwd;history -a;title_git'
#   PS1="${COLOR_BACKGROUND}\u@\h${COLOR_REGULAR} \w \$(parse_git_branch) ${COLOR_BOLD}\$${PS_CLEAR} "
#   PS1=${PS1//\\w/\$\{newPWD\}}
#     PS2="${WHITEONCYAN}>${PS_CLEAR} "
# }

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
# go to home directory
alias ~="cd ~"
# traverse directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../../"

# create a directory and cd into it
function mkcd () { 
  mkdir -p "$@" && eval cd "\"\$$#\""; 
}
# use spotlight for locate command
# http://hints.macworld.com/article.php?story=20050507212241122
function locate {
  mdfind "kMDItemDisplayName == '$@'wc"; 
}

alias rm!="rm -rf"

# ----------------------------------------------------------------------
# AUTOCOMPLETE
# ----------------------------------------------------------------------

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# autocomplete from these directories
export CDPATH=".:$HOME:$HOME/Sites:$HOME/Sites/heroku:$HOME/Dropbox/PlainText"

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
alias ll="ls -lGa"

# list dot files in directory
alias l.="ls -d .*"

# if the dircolors utility is available, set that up too
if [ "$TERM" != "dumb" ]; then
    export LS_OPTIONS='--color=always'
    eval `dircolors ~/.dircolors`
fi

alias lg="git ls -hG"


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
# use plaintext folder for notes
alias pt="cd ~/Dropbox/PlainText && ll"
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
# ZIP a file or directory
# ----------------------------------------------------------------------

# usage:  $ zip filename
function zip(){ 
  command sudo ditto -c -k -rsrc "$@" "$@.zip";
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
    command cl && thin -p "$1" start;
  else
    for port in `seq 3000 3004`; do
      if thin -p $port start; then break; fi
    done
  fi
}

# script/server
function ss(){
  title_git " /  Server"
  if [ "$1" != "" ]; then
    command cl && script/server -p "$1";
  else
    for port in `seq 3000 3004`; do
      if script/server -p $port; then break; fi
    done
  fi
}
# rails server
function rs(){
  title_git " /  Server"
  if [ "$1" != "" ]; then
    command cl && rails server -p "$1";
  else
    for port in `seq 3000 3004`; do
      if rails server -p $port; then break; fi
    done
  fi
}
# shotgun
function sg(){
  title_git " /  Server"
  if [ "$1" != "" ]; then
    command cl && shotgun -p "$1" start;
  else
    for port in `seq 3000 3004`; do
      if shotgun -p $port; then break; fi
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
alias gplh="git up heroku master"
alias gpls="git up staging staging:master"
alias gplg="git up github master"
alias gplo="git up origin master"
alias gpl="git pull"
alias gc="git commit -am"
alias gco="git checkout"
alias ga="git add ."

# ----------------------------------------------------------------------
# PROJECTS
# ----------------------------------------------------------------------

alias s="cd $HOME/Sites/"

# heroku
alias h="cd ~/Sites/heroku"
alias hp="cd ~/Sites/heroku/public"

alias navrestart='for i in "news" "success" "policy" "logos" "about" "public" "blog" "docs"; do heroku restart --app $i && sleep 1; done'

# put heroku docbrown on PATH if you have it
test -d "$HOME/sites/heroku/docbrown" &&
PATH="$HOME/sites/heroku/docbrown:$PATH"

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

function share-f(){
  if [ "$1" = "" ] && [ "$2" = ""]; then
    command echo 'appname email';
  else
    command cd ~/Sites/heroku/docbrown && ./bin/docbrown collaborator:add "$1" "$2" && cd -;
  fi
}

function share(){
  if [ "$1" != "" ]; then
    command heroku sharing:add "$@";
  else
    command heroku sharing:list;
  fi
}

# ==============================================================================
# USER SHELL ENVIRONMENT
# ==============================================================================

title_git

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_color
