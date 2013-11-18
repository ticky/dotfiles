
# retrieves IP addresses which aren't zeroconf or local-only (see also: ipls in platform/all-but-darwin/zsh/functions.zsh)
function ipls() {
  ifconfig | _inetgrep | awk '{print $2}';
}

# find command using spotlight data on OS X
function fn {
  mdfind -onlyin . "kMDItemDisplayName == '$@'wc";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}
