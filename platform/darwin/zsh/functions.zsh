# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(finder-path)"
}
