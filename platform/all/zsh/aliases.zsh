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

alias ipls="ifconfig | ipgrep"

# git aliases

# if hub is installed, enable it and add some aliases
if hub alias -s >/dev/null 2>&1; then
  eval "$(hub alias -s)"
  alias gbr="echo \"Please use \\\"git br\\\" instead.\" >&2;git br"
fi

alias ga="echo \"Please use \\\"git a\\\" instead.\" >&2;git a"
alias gb="echo \"Please use \\\"git b\\\" instead.\" >&2;git b"
alias gba="echo \"Please use \\\"git ba\\\" instead.\" >&2;git ba"
alias gc="echo \"Please use \\\"git c\\\" instead.\" >&2;git c"
alias gco="echo \"Please use \\\"git co\\\" instead.\" >&2;git co"
alias gd="echo \"Please use \\\"git d\\\" instead.\" >&2;git d"
alias gdc="echo \"Please use \\\"git dc\\\" instead.\" >&2;git dc"
alias gdh="echo \"Please use \\\"git dh\\\" instead.\" >&2;git dh"
alias gdt="echo \"Please use \\\"git dt\\\" instead.\" >&2;git dt"
alias gdtc="echo \"Please use \\\"git dtc\\\" instead.\" >&2;git dtc"
alias gdth="echo \"Please use \\\"git dth\\\" instead.\" >&2;git dth"
alias gf="echo \"Please use \\\"git f\\\" instead.\" >&2;git f"
alias gl="echo \"Please use \\\"git l\\\" instead.\" >&2;git l"
alias gp="echo \"Please use \\\"git p\\\" instead.\" >&2;git p"
alias gpl="echo \"Please use \\\"git pl\\\" instead.\" >&2;git pl"
alias gr="echo \"Please use \\\"git p\\\" instead.\" >&2;git p"
alias gs="echo \"Please use \\\"git s\\\" instead.\" >&2;git s"
alias gu="echo \"Please use \\\"git u\\\" instead.\" >&2;git u"
