
# retrieves IP addresses which aren't zeroconf or local-only (see also: ipls in platform/darwin/zsh/functions.zsh)
function ipls() {
  ip addr show | _inetgrep | awk '{split($2,array,"/")} END{print array[1]}'
}

# find command
function fn {
  # `pwd` is used because find outputs path names attached to the location you give it
  find `pwd` -name $@ 2> /dev/null
}