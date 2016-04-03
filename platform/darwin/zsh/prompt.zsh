prompt_userhost_darwin() {
  echo -n ${$(prompt_userhost)/\%m/$(scutil --get ComputerName)}
}

PROMPT=${PROMPT/prompt_userhost/prompt_userhost_darwin}
