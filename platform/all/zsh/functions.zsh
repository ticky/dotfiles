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

if python --version >/dev/null 2>&1; then
function simplify {
python - <<END
from fractions import Fraction

if('/' in '$1'):
  frac = Fraction('$1')
else:
  frac = Fraction($1, $2)

print(str(frac))
END
}
fi

# suppress "Boot" app in dock when running an app in the Play framework
if /usr/libexec/java_home >/dev/null 2>&1 && play --version >/dev/null 2>&1; then
  function play() {
    clear 2>/dev/null
    if [ $# -eq 0 ]; then
      # automatically "run" if there are no arguments
      echo "run\n" > /tmp/playrunner
      cat /tmp/playrunner - | _JAVA_OPTIONS="-Djava.awt.headless=true" command play
      rm /tmp/playrunner
    else
      _JAVA_OPTIONS="-Djava.awt.headless=true" command play $@
    fi

    # restore echo after play 2.1.3+ murders it (Java is great)
    stty echo
  }
fi
