#!/bin/bash
# Geoff Stokes <http://github.com/geoffstokes/dotfiles>

# ==============================================================================
# VARIABLES & BASIC CONFIGURATION
# ==============================================================================

# set a variable with the home dir's location (adding "~" to PATH doesn't work)
: ${HOME=~}

# kernel name
: ${UNAME=$(uname | tr '[A-Z]' '[a-z]')}

# working around Cygwin weirdness
# NOTE: On Linux and Darwin (and likely FreeBSD), `uname` returns the kernel name.
#       On Cygwin, you get a long string including CYGWIN, kernel version and architecture.
#       We override Cygwin's entry for brevity here.
`uname -o > /dev/null 2>&1` && if [ `uname -o` = "Cygwin" ]; then
  UNAME="cygwin"
fi

# coreutils type
COREUTILS="OTHER"

# presence of additional g-prefixed coreutils
GCOREUTILS="NO"

# detect coreutils' type by throwing -G at BSD ls
if ls -G >/dev/null 2>&1; then
  COREUTILS="BSD"

  # detect additional GNU Coreutils (i.e. `brew install coreutils` on OS X)
  if gls > /dev/null 2>&1; then
    GCOREUTILS="YES"
  fi

elif ls --color=auto >/dev/null 2>&1; then
  COREUTILS="GNU"
fi

# default editor is vim
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

function platformbindir {
  if [ -d "$HOME/dotfiles/bin/$UNAME" ]; then
    echo "$HOME/dotfiles/bin/$UNAME"
  else
    mkdir "$HOME/dotfiles/bin/$UNAME" && PATH="$HOME/dotfiles/bin/$UNAME:$PATH" && echo "$HOME/dotfiles/bin/$UNAME:$PATH"
  fi
}

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
  title `echo ${PWD} "$(_git_prompt) $@"`
}

# ----------------------------------------------------------------------
#  PROMPT
# ----------------------------------------------------------------------

# checks the current repo's email against the global value; if they don't match, show the repo's value.
function _git_prompt_local_email {
  [[ $(git config user.email) != $(git config --global user.email) ]] && echo "`git config user.email` "
}
# detect if there are changes to the local working copy
function _git_prompt_dirty_marker {
  [ -z "$(git status -s 2> /dev/null)" ] || echo " ●"
}
# Serves two functions; shows the current branch (in place of `\1`),
# and if `git branch` returns a failure code, outputs nothing (i.e. hides the git prompt, and never calls the sub-functions).
function _git_prompt {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/✱ $(_git_prompt_local_email)⌥ \1$(_git_prompt_dirty_marker)/"
}


# Hide hostname in prompt while inside a GNU Screen session on Linux.
# (Hostname is always shown in hardstatus inside Screen)
# TODO:
# - Expand this to allow for tmux
# - Find a way to implement similar behaviour on OS X (Cygwin/MSYS should be the same as this)
# - Show hostname if inside a remote ssh session (Maybe?)

# "athost" variable is for disabling hostname in certain situations
ATHOST="@\h"

if [ "$UNAME" = "linux" ]; then
  if [[ `cat /proc/$PPID/cmdline` == SCREEN* ]] ; then
    ATHOST=""
  fi
fi

# prompt setup functions
function prompt_pwd() {
  # This sets up the newPWD value which is used in the prompt and the title.
  # It is run after every command by the PROMPT_COMMAND variable.
  newPWD="${PWD} $(_git_prompt)"
}
function prompt_color() {
  PROMPT_COMMAND='prompt_pwd;history -a;title_git'

  # Set up prompt.
  PS1="${COLOR_BACKGROUND}\u${ATHOST}${COLOR_REGULAR}:\w\n${COLOR_BOLD}>${COLOR_DEFAULT} "

  # Replace "\w" with the newPWD variable set in prompt_pwd
  # (This syntax is evaluated when the prompt is rendered; the one above is evaluated once)
  # TODO: Investigate why.
  PS1=${PS1//\\w/\$\{newPWD\}}

  # multi-line command input prompt
  PS2="${COLOR_REGULAR}>${COLOR_DEFAULT} "
}

# ----------------------------------------------------------------------
#  AUTOCOMPLETE
# ----------------------------------------------------------------------

# OS X-specific autocompletions
if [ "$UNAME" = "darwin" ]; then
  # if homebrew's bash_completion is installed, bring it in
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
  # Add `killall` tab completion for common apps - Borrowed from https://github.com/mathiasbynens/dotfiles/
  complete -o "nospace" -W "Adium Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
fi

# ----------------------------------------------------------------------
#  LS AND DIRCOLORS
# ----------------------------------------------------------------------

if [ "$COREUTILS" = "BSD" ]; then
  # If BSD Coreutils has been detected, set up BSD ls

  # Use environment variable rather than alias to enable colours.
  export CLICOLOR="yes"

  # Configure ls colours
  #
  #                +-Directory (Cyan)
  #                | +-Symlink (Magenta)
  #                | | +-Socket (Magenta)
  #                | | | +-Pipe (Green)
  #                | | | | +-Executable (Magenta)
  #                | | | | | +-Block Special (Green on Cyan)
  #                | | | | | | +-Character Special (Green on Brown)
  #                | | | | | | | +-Executable with setuid set (Magenta on Red)
  #                | | | | | | | | +-Executable with setgid set (Magenta on Green)
  #                | | | | | | | | | +-Directory writable to others, with sticky bit (Black on Green)
  #                | | | | | | | | | | +-Directory writable to others, without sticky bit (Black on Brown)
  #                | | | | | | | | | | | 
  export LSCOLORS="GxfxFxcxFxcgcdfbfgacad"
  # See `man ls` on a Mac or FreeBSD system for info on this

  # setup the main ls alias
  alias ls='ls -h'

  # list all files in directory
  alias ll="ls -ahl"

  # list dot files in directory
  alias l.="ls -dh .*"

  # Support for additional GNU Coreutils
  if [ "$GCOREUTILS" = "YES" ]; then
    # If the GNU Coreutils are included as "gls"

    # setup the main ls alias
    alias gls='gls -h --color'

    # list all files in directory
    alias gll="gls -ahl --color"

    # list dot files in directory
    alias gl.="gls -dh --color .*"
  fi

elif [ "$COREUTILS" = "GNU" ]; then
  # If we haven't found BSD Coreutils, it's pretty likely we're on a GNU system.

  # setup the main ls alias
  alias ls='ls -h --color'

  # list all files in directory
  alias ll="ls -ahl --color"

  # list dot files in directory
  alias l.="ls -dh --color .*"
fi

# GNU ls' colours are defined in ~/.dircolors
eval $(dircolors -b ~/.dircolors 2>/dev/null)

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
    command $EDITOR $HOME/dotfiles;
  elif [ "$1" = "load" ]; then
    command source $HOME/.bash_profile;
  elif [ "$1" = "install" ]; then
    command $HOME/dotfiles/install.sh && \
      profile load;
  else
    echo "Usage: profile <command>"
    echo ""
    echo "Commands:"
    echo "    edit"
    echo "        Open the dotfiles directory in \"$EDITOR\""
    echo ""
    echo "    load"
    echo "        Reload the configuration (Applies only to bash_profile)"
    echo ""
    echo "    install"
    echo "        Run the dotfiles installer again (to add new files)"
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
  if [ "$UNAME" = "darwin" ]; then
    mdfind -onlyin . "kMDItemDisplayName == '$@'wc";
  else
    find `pwd` -name $@ 2> /dev/null
  fi
}

if python --version >/dev/null 2>&1; then
  alias shttp="python -m SimpleHTTPServer"
else
  alias shttp="echo \"Python was not found.\""
fi

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
