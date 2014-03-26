# detect coreutils' type by throwing --color=auto at GNU ls
if ls --color=auto ~ >/dev/null 2>&1; then

  # Is GNU Coreutils has been detected, set up GNU ls

  # setup the main ls alias
  alias ls='ls -h --color'

  # list all files in directory
  alias ll="ls -ahl --color"

  # list dot files in directory
  alias l.="ls -dh --color .*"

else

  # BSD ls errors out when passed `--color`, GNU ls doesn't seem to care about unexpected arguments

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

fi

# GNU ls' colours are defined in ~/.dircolors
eval $(dircolors -b ~/.dircolors 2>/dev/null)

# coloured man pages
alias man="mansi"

alias rm!="rm -rf"

# close window
alias x="exit"
alias :q="exit"
# clear window
alias cl="clear"

alias ipls="ifconfig | ipgrep"

# git aliases

# if hub is installed, enable it and add some aliases
if hub alias -s >/dev/null 2>&1; then
  eval "$(hub alias -s)"
  alias gbr="echo \"Please use \\\"git br\\\" instead.\" >&2;git br"
fi
