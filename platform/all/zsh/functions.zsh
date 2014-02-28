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
    mkdir -p "$HOME/dotfiles/platform/$UNAME/bin" && PATH="$HOME/dotfiles/platform/$UNAME/bin:$PATH" && echo "$HOME/dotfiles/platform/$UNAME/bin"
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

# retrieves the last (hopefully most relevant) IP address in the `ipls` list
function cip() {
  ipls | tail -1
}

# coloured manual pages
function man() {

  # This is a *hack*; overrides the TERMCAP for `man`'s output
  # `tput` should make this safe-ish for use on basic terminals though? maybe?

  # More info on variables;
  # http://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables

  # "start blink mode" (mb)
  # * used for: not sure
  # * shown as: bold cyan

  # "start bold mode" (md)
  # * used for: headings, argument names and keywords
  # * shown as: dim bold cyan

  # "start standout mode" (so)
  # * used for: status bar
  # * shown as: bold white on magenta

  # "start underline mode" (us)
  # * used for: argument values, file names
  # * shown as: underlined green

  # "end mode" (me)
  # "end standout mode" (se)
  # "end underline mode" (ue)

  env LESS_TERMCAP_mb=$(tput bold; tput setaf 6) \
      LESS_TERMCAP_md=$(tput bold; tput setaf 6; tput dim) \
      LESS_TERMCAP_so=$(tput bold; tput setaf 7; tput setab 5) \
      LESS_TERMCAP_us=$(tput smul; tput setaf 2) \
      LESS_TERMCAP_me=$(tput sgr0) \
      LESS_TERMCAP_se=$(tput rmso; tput sgr0) \
      LESS_TERMCAP_ue=$(tput rmul; tput sgr0) \
  man "$@"

}

# create a directory and cd into it
# http://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/
function mkcd() {
  mkdir -p "$@" && eval cd "$@";
}

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
