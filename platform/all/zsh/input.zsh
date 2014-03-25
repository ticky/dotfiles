bindkey -e

# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line

# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# for freebsd / OS X console
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# for OS X tmux
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line

# Up/down arrow.
# I want shared history for ^R, but I don't want another shell's activity to
# mess with up/down.  This does that.
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history

bindkey "\e[A" up-line-or-local-history
bindkey "\e[B" down-line-or-local-history