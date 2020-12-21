export HOMEBREW_INSTALL_BADGE=✨         # Sparkles!!!
export HOMEBREW_IS_FOR_WITCHES=OBVIOUSLY # Future proofing
export HOMEBREW_NO_AUTO_UPDATE=TRUE      # Please stop breaking things
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE  # I appreciate the gesture, but maybe ask first

export MAKEFLAGS="-j $(printf "%.0f" $(( $(sysctl -n hw.ncpu) * 1.5 )))" # Configure `make` to use all available cores as best it can
