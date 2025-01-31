# disable ctrl-d quitting shell directly
# setopt IGNORE_EOF

# Fix: 'zvm_cursor_style:33: failed to compile regex: trailing backslash (\)' on every command entered on Termux
# From github issue solution: fix On macOS (homebrew) and Linux (DNF/Fedora), zsh supports PCRE by default, 
# apparently this issue will only occur on FreeBSD using pre-compiled packages. 
setopt re_match_pcre

# stop accident : to trigger 'execute-named-cmd'
bindkey -a -r ':'
