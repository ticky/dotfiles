# suppress "Boot" app in dock when running an app in the Play framework
if /usr/libexec/java_home >/dev/null 2>&1 && play --version >/dev/null 2>&1; then
  play() {
    clear 2>/dev/null
    if [[ $# -eq 0 ]]; then
      # automatically "run" if there are no arguments
      printf "run\n" > /tmp/playrunner
      cat /tmp/playrunner - | _JAVA_OPTIONS="-Djava.awt.headless=true" command play
      rm /tmp/playrunner
    else
      _JAVA_OPTIONS="-Djava.awt.headless=true" command play $@
    fi

    # restore echo after play 2.1.3+ murders it (Java is great)
    stty echo
  }
fi
