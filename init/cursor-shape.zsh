# use vi-mode in zsh
bindkey -v

# Change cursor shape for different vi modes.
# Set cursor style (DECSCUSR), VT520.
# 0  ⇒  blinking block.
# 1  ⇒  blinking block (default).
# 2  ⇒  steady block.
# 3  ⇒  blinking underline.
# 4  ⇒  steady underline.
# 5  ⇒  blinking bar, xterm.
# 6  ⇒  steady bar, xterm.
zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne '\e[2 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne '\e[6 q'
    fi
}
zle -N zle-keymap-select

# initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
zle-line-init() {
    zle -K viins 
    echo -ne "\e[6 q"
}
zle -N zle-line-init

# Use beam shape cursor on startup.
# echo -ne '\e[6 q' 

# Use beam shape cursor for each new prompt.
# preexec() { echo -ne '\e[6 q' ; }

