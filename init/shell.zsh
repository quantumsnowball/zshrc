# disable ctrl-d quitting shell directly
# setopt IGNORE_EOF

# Fix: 'zvm_cursor_style:33: failed to compile regex: trailing backslash (\)' on every command entered on Termux
# From github issue solution: fix On macOS (homebrew) and Linux (DNF/Fedora), zsh supports PCRE by default, 
# apparently this issue will only occur on FreeBSD using pre-compiled packages. 
setopt re_match_pcre

# stop accident : to trigger 'execute-named-cmd'
bindkey -a -r ':'

# fix insert mode backspace key and delete key
# (allow delete char not created by insert mode)
bindkey "^?" backward-delete-char
bindkey "\e[3~" delete-char

# vi mode key bindings
# Home, End
bindkey -M vicmd 'gh' vi-beginning-of-line
bindkey -M vicmd 'gl' vi-end-of-line
# navigate word using H, L
bindkey -M vicmd 'L' vi-forward-blank-word-end
bindkey -M vicmd 'H' vi-backward-blank-word

