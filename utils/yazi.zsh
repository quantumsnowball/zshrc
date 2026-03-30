ensure yazi || return

#
# Shell wrapper
# Official doc suggests using this y shell wrapper that provides the ability to change the
# current working directory when exiting Yazi
#
# Usage:
# Use y instead of yazi to start, and press q to quit, you'll see the CWD changed.
# Sometimes, you don't want to change, press Q to quit.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
