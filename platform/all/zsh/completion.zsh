# Use `man`'s completion function for `mansi`
compdef _man mansi

# Use `ssh`'s completion function for `sshmux`
_sshmux () {
	local service=ssh
	_ssh "$@"
}
compdef _sshmux sshmux
