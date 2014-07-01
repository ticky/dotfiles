setopt AUTO_CD # when a directory name is entered, just cd to it
setopt AUTO_PUSHD # automatically push directories cd'd to into the directory stack
setopt CHASE_DOTS # if a typed path contains `..`, show it with the directory above it removed
setopt COMPLETE_ALIASES # allow autocompleting aliases
setopt COMPLETE_IN_WORD # allow completion mid-word
setopt CORRECT # use typo correction 
setopt IGNORE_EOF # do not exit on end-of-file
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP # background jobs may outlive zsh sessions
setopt NO_LIST_BEEP # only beep if a completion is ambiguous
setopt PROMPT_SUBST # allow substitution in the prompt
setopt PRINT_EXIT_VALUE # print non-zero exit values
                        # (note: zsh outputs a helpful message when processes are terminated/killed,
                        # but not for things run via sudo; this does)

REPORTTIME=5 # display timing information when a command takes longer than 5 seconds
