# detect coreutils' type by throwing -G at BSD ls
if ls -G >/dev/null 2>&1; then

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

  if gls > /dev/null 2>&1; then
    # If the GNU Coreutils are included as "gls"

    # setup the main ls alias
    alias gls='gls -h --color'

    # list all files in directory
    alias gll="gls -ahl --color"

    # list dot files in directory
    alias gl.="gls -dh --color .*"
  fi

elif ls --color=auto >/dev/null 2>&1; then
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

alias rm!="rm -rf"

# close window
alias x="exit"
alias :q="exit"
# clear window
alias cl="clear"

# git aliases

# if hub is installed, enable it and add some aliases
if hub alias -s >/dev/null 2>&1; then
  eval "$(hub alias -s)"
  alias gbr="git browse"
fi

alias ga="git add ."
alias gb="git branch -avv --no-merged"
alias gba="git branch -av"
alias gc="git commit -v"
alias gco="git checkout"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdh="git diff HEAD"
alias gdt="git difftool"
alias gdtc="git difftool --cached"
alias gdth="git difftool HEAD"
alias gf="git fetch"
alias gl="git log"
alias gp="git push"
alias gpl="git pull"
alias gr="git remote -v"
alias gs="git status"
alias gu="git up"
