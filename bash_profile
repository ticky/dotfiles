#!/bin/bash
# seaofclouds <http://seaofclouds.com> with help from: 
# Ryan Tomayko <http://tomayko.com/about> (with help from the internets).

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

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

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# color chart: http://www.ibm.com/developerworks/linux/library/l-tip-prompt/
WHITEONPINK="\[\033[37;45;1m\]"
PINK="\[\033[0;35m\]"
TEAL="\[\033[0;36m\]"
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

prompt_color() {
  PS1="${WHITEONPINK}[\u@\h]${PS_CLEAR}${PINK} \w\$(parse_git_branch) \$${PS_CLEAR} "
    PS2="${TEAL}>${PS_CLEAR} "
}

# ----------------------------------------------------------------------
# TITLE
# ----------------------------------------------------------------------

#set window title
function title() { echo -ne "\033]0;$@\007"; }
title `echo ${PWD##*/}`

# ----------------------------------------------------------------------
# AUTOCOMPLETE
# ----------------------------------------------------------------------

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# make tab cycle through commands instead of listing 
# http://www.macosxhints.com/article.php?story=20050904022246573&lsrc=osxh
bind '"\t":menu-complete'

function cd() { 
  # supress bash_completion pwd on cd
  command cd "$@" >/dev/null; 
  # title window on cd
  title `echo ${PWD##*/}`; 
}

# autocomplete from these directories
export CDPATH=".:~:~/Sites:~/Sites/heroku"

#directory navigation
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../../"

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

# we always pass these to ls(1)
LS_COMMON="-hBG"

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
}
unset dircolors

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias ll="ls -la"
alias l.="ls -d .*"

# ----------------------------------------------------------------------
# ALIASES / FUNCTIONS
# ----------------------------------------------------------------------

alias dotfiles="mate ~/Dotfiles/"
# edit this file
alias settings="mate ~/Dotfiles/bash_profile"
alias reload="source ~/Dotfiles/bash_profile"

# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'

# find
alias fn='find . -name'

# history
HISTIGNORE="ls:ll:cl:s:ts:x:mate*:&"
alias hi='history | tail -20'

# gem install
alias sgi32="sudo env ARCHFLAGS=\"-Os -arch i386 -fno-common\" gem install --no-ri --no-rdoc"
alias sgi64="sudo env ARCHFLAGS=\"-Os -arch x86_64 -fno-common\" gem install --no-ri --no-rdoc"
alias sgi="sudo env ARCHFLAGS=\"-Os -arch x86_64 -fno-common\" gem install --no-ri --no-rdoc"


alias x="exit"
alias cl="clear"
alias m.="mate ."

# thin start
function ts(){
  title server
  for ((port=3000; port <= 3010 ; port++)); do
      thin $options -p $port start;
     if [ $? == 0 ]; then break; fi
  done
}

# mongrel rails start
function mrs(){
  title server
  for ((port=3000; port <= 3010 ; port++)); do
      mongrel_rails $options -p $port start;
     if [ $? == 0 ]; then break; fi
  done
}

# postgresql, psql
alias pgstop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"

# mongo
alias mstart="/usr/local/bin/mongod --dbpath=/Users/todd/Sites/_mongodata/"

# git
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

#rake
alias rdm="rake db:migrate"
alias rdfl="rake db:fixtures:load"

#projects
alias s="cd ~/Sites/"
alias cdtmb="cd ~/Library/Application\ Support/TextMate/Bundles/"

# heroku
alias h="cd ~/Sites/heroku"
alias navrestart='for i in "business" "news" "success" "legal" "logos" "about" "public" "blog" "docs"; do heroku restart --app $i && sleep 1; done'

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_color
