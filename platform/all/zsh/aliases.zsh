alias rm!="rm -rf"

# close window
alias x="exit"
alias :q="exit"
# clear window
alias cl="clear"

# git aliases

# if hub is installed, enable it
hub alias -s >/dev/null 2>/dev/null && eval "$(hub alias -s)"
alias ga="git add ."
alias gb="git branch -av"
alias gbr="git branch -avv --no-merged"
alias gc="git commit -v"
alias gco="git checkout"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdh="git diff HEAD"
alias gdt="git difftool"
alias gf="git fetch"
alias gl="git log"
alias gp="git push"
alias gpl="git pull"
alias gr="git remote -v"
alias gs="git status"
alias gu="git up"