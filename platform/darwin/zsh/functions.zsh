# Change working directory to the top-most Finder window location
cdf() { # short for `cdfinder`
  cd "$(finder-path)"
}
