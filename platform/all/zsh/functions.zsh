userIsRoot() {
  [[ "$(env whoami)" = "root" ]]
}
platformIsDarwin() {
  [[ "$UNAME" = "darwin" ]]
}
platformIsLinux() {
  [[ "$UNAME" = "linux" ]]
}
platformIsCygwin() {
  [[ "$UNAME" = "cygwin" ]]
}

sessionIsLocal() {
  [[ $SSH_CONNECTION == '' && $TERM != "screen"* ]]
}

_hex_split() {
  rgb=

  if [[ ${#1} -eq 6 ]]; then
    rgb=($(chcase upper "${1:0:2} ${1:2:2} ${1:4:2}"))
  elif [[ ${#1} -eq 3 ]]; then
    rgb=($(chcase upper "${1:0:1}${1:0:1} ${1:1:1}${1:1:1} ${1:2:1}${1:2:1}"))
  fi

  echo $rgb
}

_base_16_to_10() {
  echo "ibase=16; $(chcase upper "$1")" | bc
}

_hex_to_rgb() {
  rgb=($(_hex_split "$1"))
  echo "$(_base_16_to_10 $rgb[1]),$(_base_16_to_10 $rgb[2]),$(_base_16_to_10 $rgb[3])"
}

platformbindir() {
  if [[ -d "$DOTFILES/platform/$UNAME/bin" ]]; then
    echo "$DOTFILES/platform/$UNAME/bin"
  else
    mkdir -p "$DOTFILES/platform/$UNAME/bin" && PATH="$DOTFILES/platform/$UNAME/bin:$PATH" && echo "$DOTFILES/platform/$UNAME/bin"
  fi
}

dotfiles() {
  case $1 in
    edit|ed|e)
      command "$EDITOR" "$DOTFILES"
      ;;
    load|lo|l)
      source "$HOME/.zshrc"
      ;;
    install|inst|in|i)
      command "$DOTFILES/install.sh" && \
      $0 load
      ;;
    update|up|u)
      cd "$DOTFILES" && \
      command git stash && \
      command git pull && \
      command git stash pop && \
      cd - && \
      $0 install
      ;;
    *)
      echo "Usage: $0 <command>" && \
      echo && \
      echo "Commands:" && \
      echo "    edit, ed, e" && \
      echo "        Open the dotfiles directory in \"$EDITOR\"" && \
      echo && \
      echo "    load, lo, l" && \
      echo "        Reload the configuration (Applies only to zshrc)" && \
      echo && \
      echo "    install, inst, in, i" && \
      echo "        Run the dotfiles installer again (to add new files)" && \
      echo && \
      echo "    update, up, u" && \
      echo "        Fetch updated version of dotfiles and install them"
      ;;
  esac
}

# retrieves the last (hopefully most relevant) IP address in the `ipls` list
cip() {
  ipls | tail -1
}

# create a directory and cd into it
# http://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/
mkcd() {
  mkdir -p "$@" && eval cd "$@";
}
