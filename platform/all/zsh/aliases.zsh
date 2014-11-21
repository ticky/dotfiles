# LS Alias definitions

# main ls alias
LS="ls -hF"  # `-h` enables "human" units for file sizes, `-F` shows characters to denote directory and file types
LL="${LS}Al" # `-A` shows all files except `.` and `..`, `-l` shows list in a long format
LD="${LS}d"  # `-d` shows directories as regular files (allows limiting display to current directory rather than listing contents of subdirectories)

# detect coreutils' type by throwing --color=auto at GNU ls
if ls --color=auto ~ >/dev/null 2>&1; then

  # If GNU Coreutils has been detected, configure aliases to use `--color`

  LS="${LS} --color"
  LL="${LL} --color"
  LD="${LD} --color"

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

  # Support for additional GNU Coreutils

  if gls > /dev/null 2>&1; then
    # If the GNU Coreutils are included as "gls"

    # setup the main ls alias
    alias gls="g${LS} --color"

    # list all files in directory
    alias gll="g${LL} --color"

    # list dot files in directory
    alias gl.="g${LD} --color .*"
  fi

fi

# setup the main ls alias
alias ls="${LS}"

# list all files in directory
alias ll="${LL}"

# list dot files in directory
alias l.="${LD} .*"

# GNU ls' colours are defined in ~/.dircolors
eval $(dircolors -b ~/.dircolors 2>/dev/null)

alias disk-usage="du -h"
alias disk-free="df -h"

# coloured man pages
alias man="mansi"

alias man-update="ronn --roff --markdown --manual \"Jessica Stokes' Dotfiles\" $DOTFILES/platform/*/man/**/*.ronn"

alias rm!="rm -rf"

# close window
alias x="exit"
alias q="exit"
alias :q="exit"

alias ipls="ifconfig | ipgrep"

alias killall="killall -v"
