#!/bin/bash
# Geoff Stokes <http://github.com/geoffstokes/dotfiles>

# ==============================================================================
# VARIABLES & BASIC CONFIGURATION
# ==============================================================================

# the basics
: ${HOME=~}
: ${UNAME=$(uname)}
: ${EDITOR=vim}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# ----------------------------------------------------------------------
#  COLOUR DEFINITIONS
# ----------------------------------------------------------------------

# "\[\033[0;35m\]" // Purple

COLOR_DEFAULT="\[\033[0m\]" # Terminal Default Colours
SCREEN_ESC="\[\033k\033\134\]" # Screen Escape

# root gets a cyan prompt by default
if [ `env whoami` = "root" ] ; then
  COLOR_BACKGROUND="\[\033[0;46;1m\]" # White on Cyan
  COLOR_REGULAR="\[\033[0;36m\]" # Cyan
  COLOR_BOLD="\[\033[0;36;1m\]" # Bold Cyan
else
  COLOR_BACKGROUND="\[\033[0;45;1m\]" # White on Magenta
  COLOR_REGULAR="\[\033[0;35m\]" # Magenta
  COLOR_BOLD="\[\033[0;35;1m\]" # Bold Magenta
fi

# ----------------------------------------------------------------------
#  PATH
# ----------------------------------------------------------------------

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# All-OS user bin
test -d "$HOME/dotfiles/bin" &&
PATH="$HOME/dotfiles/bin:$PATH"

# Allow platform-based overrides
test -d "$HOME/dotfiles/bin/$UNAME" &&
PATH="$HOME/dotfiles/bin/$UNAME:$PATH"

# Cygwin-specific platform overrides
`uname -o > /dev/null 2> /dev/null` && if [ `uname -o` = "Cygwin" ]; then
  test -d "$HOME/dotfiles/bin/Cygwin" &&
  PATH="$HOME/dotfiles/bin/Cygwin:$PATH"
fi

# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"


# ==============================================================================
# SETTINGS
# ==============================================================================

# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

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

# default umask
umask 0022

# ----------------------------------------------------------------------
#  WINDOW TITLE
# ----------------------------------------------------------------------

# set window title
function title() {
  echo -ne "\033]0;$@\007";
}
function title_git() {
  title `echo ${PWD} "$(parse_git_branch) $@"`
}

# ----------------------------------------------------------------------
#  PROMPT
# ----------------------------------------------------------------------

# git info for prompt
function parse_git_email {
  [[ $(git config user.email) != $(git config --global user.email) ]] && echo "`git config user.email` "
}
function parse_git_dirty {
  [ -z "$(git status -s 2> /dev/null)" ] || echo " ●"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/✱ $(parse_git_email)⌥ \1$(parse_git_dirty)/"
}


# Hide hostname in prompt while inside a GNU Screen session on Linux.
# (Hostname is always shown in hardstatus inside Screen)
# TODO:
# - Expand this to allow for tmux
# - Find a way to implement similar behaviour on OS X (Cygwin/MSYS should be the same as this)
# - Show hostname if inside a remote ssh session (Maybe?)
# - Double check that running this once per session is safe (I'm pretty sure it is...)
ATHOST="@\h"
if [ "$UNAME" = "Linux" ]; then
  if [[ `cat /proc/$PPID/cmdline` == SCREEN* ]] ; then
    ATHOST=""
  fi
fi

# prompt setup functions
function prompt_pwd() {
  newPWD="${PWD} $(parse_git_branch)"
}
function prompt_color() {
  PROMPT_COMMAND='prompt_pwd;history -a;title_git'
  PS1="${COLOR_BACKGROUND}\u${ATHOST}${COLOR_REGULAR}:\w\n${COLOR_BOLD}>${COLOR_DEFAULT} "
  PS1=${PS1//\\w/\$\{newPWD\}}
    PS2="${COLOR_REGULAR}>${COLOR_DEFAULT} "
}

# ----------------------------------------------------------------------
#  AUTOCOMPLETE
# ----------------------------------------------------------------------

if [ "$UNAME" = "Darwin" ]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
  # Add `killall` tab completion for common apps - Borrowed from https://github.com/mathiasbynens/dotfiles/
  complete -o "nospace" -W "Adium Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
fi

# ----------------------------------------------------------------------
#  LS AND DIRCOLORS
# ----------------------------------------------------------------------

if [ "$UNAME" = "Darwin" ]; then
  # If we're on Darwin, assume we're using BSD utilities
  # setup the main ls alias
  alias ls='ls -hG'

  # list all files in directory
  alias ll="ls -lGah"

  # list dot files in directory
  alias l.="ls -dGh .*"
else
  # We're on something else - assume GNU utilities (TODO: Make this work correctly on BSDs)
  # setup the main ls alias
  alias ls='ls -h --color'

  # list all files in directory
  alias ll="ls -lah --color"

  # list dot files in directory
  alias l.="ls -dh --color .*"
fi

# ----------------------------------------------------------------------
#  COMMAND HISTORY
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
export HISTIGNORE="&:cl:x:exit"

# ==============================================================================
# ALIASES & FUNCTIONS
# ==============================================================================

# ----------------------------------------------------------------------
#  CD, DIRECTORY NAVIGATION
# ----------------------------------------------------------------------

function profile() {
  if [ "$1" = "edit" ]; then
    command cd $HOME/dotfiles && command $EDITOR .;
  elif [ "$1" = "load" ]; then
    command source $HOME/.bash_profile;
  elif [ "$1" = "install" ]; then
    command cd $HOME/dotfiles/ && ruby $HOME/dotfiles/install.rb && \
      profile load;
  else
    echo "AVAILABLE COMMANDS: edit, load, install"
  fi
}
alias p="profile"

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
function mkcd() {
  mkdir -p "$@" && eval cd "\"\$$#\"";
}

# crossplatform find command - uses spotlight data on OS X
function fn {
  if [ "$UNAME" = "Darwin" ]; then
    mdfind -onlyin . "kMDItemDisplayName == '$@'wc";
  else
    find `pwd` -name $@ 2> /dev/null
  fi
}

alias shttp="python -m SimpleHTTPServer"

alias rm!="rm -rf"

# close window
alias x="exit"
alias :q="exit"
# clear window
alias cl="clear"

# ----------------------------------------------------------------------
#  GIT
# ----------------------------------------------------------------------

alias gd="git diff"
alias gl="git log"
alias gu="git up"
alias gs="git status"
alias gf="git fetch"
alias gr="git remote -v"
alias gp="git push"
alias gpl="git pull"
alias gc="git commit"
alias gco="git checkout"
alias ga="git add ."

# ==============================================================================
# FINAL SETUP
# ==============================================================================

title_git

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_color
