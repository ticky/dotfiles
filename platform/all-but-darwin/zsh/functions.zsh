
# retrieves IP addresses which aren't zeroconf or local-only (see also: ipls in platform/darwin/zsh/functions.zsh)
function ipls() {
  ip addr show | _inetgrep | awk '{split($2,array,"/")} END{print array[1]}'
}