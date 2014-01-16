function userIsRoot {
  [ `env whoami` = "root" ]
}
function platformIsDarwin {
  [ "$UNAME" = "darwin" ]
}
function platformIsLinux {
  [ "$UNAME" = "linux" ]
}
function platformIsCygwin {
  [ "$UNAME" = "cygwin" ]
}

function sessionIsLocal {
  [[ $SSH_CONNECTION == '' && $TERM != "screen"* ]]
}

function uppercase { echo -n $@ | tr '[:lower:]' '[:upper:]' }
function lowercase { echo -n $@ | tr '[:upper:]' '[:lower:]' }

# Colour test script
# Imported from https://code.google.com/p/iterm2/source/browse/trunk/tests/colors.sh
function colourtest {
  # Default test text
  T='gYw'

  if [ -n "$1" ]; then
    T=${1:0:3}
  fi

  echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
}

function _hex_split {
  rgb=

  if [ ${#1} -eq 6 ]; then
    rgb=(`uppercase "${1:0:2} ${1:2:2} ${1:4:2}"`)
  elif [ ${#1} -eq 3 ]; then
    rgb=(`uppercase "${1:0:1}${1:0:1} ${1:1:1}${1:1:1} ${1:2:1}${1:2:1}"`)
  fi

  echo $rgb
}

function _base_16_to_10 {
  echo "ibase=16; `uppercase $1`" | bc
}

function _hex_to_rgb {
  rgb=(`_hex_split $1`)
  echo "`_base_16_to_10 $rgb[1]`,`_base_16_to_10 $rgb[2]`,`_base_16_to_10 $rgb[3]`"
}

function platformbindir {
  if [ -d "$HOME/dotfiles/platform/$UNAME/bin" ]; then
    echo "$HOME/dotfiles/platform/$UNAME/bin"
  else
    mkdir -p "$HOME/dotfiles/platform/$UNAME/bin" && PATH="$HOME/dotfiles/platform/$UNAME/bin:$PATH" && echo "$HOME/dotfiles/platform/$UNAME/bin:$PATH"
  fi
}

function profile() {
  if [ "$1" = "edit" ]; then
    command $EDITOR $HOME/dotfiles;
  elif [ "$1" = "load" ]; then
    source $HOME/.zshrc;
  elif [ "$1" = "install" ]; then
    command $HOME/dotfiles/install.sh && \
      profile load;
  elif [ "$1" = "update" ]; then
    command cd ~/dotfiles && \
      command git stash && \
      command git fetch && \
      command git stash pop && \
      cd - && \
      profile install
  else
    echo "Usage: profile <command>"
    echo
    echo "Commands:"
    echo "    edit"
    echo "        Open the dotfiles directory in \"$EDITOR\""
    echo
    echo "    load"
    echo "        Reload the configuration (Applies only to zshrc)"
    echo
    echo "    install"
    echo "        Run the dotfiles installer again (to add new files)"
    echo
    echo "    update"
    echo "        Fetch updated version of dotfiles and install them"
  fi
}
alias p="profile"

# create a directory and cd into it
# http://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/
function mkcd() {
  mkdir -p "$@" && eval cd "$@";
}

# filter out local and zeroconf addresses
function _inetgrep() {
  grep inet | grep -v ' 127.' | grep -v ' ::1 ' | grep -v ' 169.254.' | grep -v ' fe80'
}

# retrieves the last (hopefully most relevant) IP address in the `ipls` list (see all-but-darwin and darwin for `ipls`)
function cip() {
  ipls | tail -1
}

function gz() {
  local origsize=$(wc -c < "$1")
  local gzipsize=$(gzip -c "$1" | wc -c)
  local ratio=$(echo "$gzipsize * 100/ $origsize" | bc -l)
  printf "orig: %d bytes\n" "$origsize"
  printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

if builtin command md5 -s "" >/dev/null 2>&1; then
  function gravatar() {
    echo "http://www.gravatar.com/avatar/`lowercase $1 | tr -d '\n ' | md5 -q`"
  }
elif builtin command md5sum --version >/dev/null 2>&1; then
  function gravatar() {
    echo "http://www.gravatar.com/avatar/`lowercase $1 | tr -d '\n ' | md5sum | awk '{print $1}'`"
  }
fi

# the tar command is bad and you should feel bad
function untar() {
  if [[ $1 =~ .*\.gz ]]; then
    command tar xvfz $1
  else
    command tar xvf $1
  fi
}

# suppress "Boot" app in dock when running an app in the Play framework
if /usr/libexec/java_home >/dev/null 2>&1 && play --version >/dev/null 2>&1; then
  function play {
    clear 2>/dev/null
    _JAVA_OPTIONS="-Djava.awt.headless=true" command play $@
    # restore echo after play 2.1.3+ murders it (Java is great)
    stty echo
  }
fi
