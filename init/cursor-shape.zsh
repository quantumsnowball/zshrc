# use vi-mode in zsh
bindkey -v

# visual selection yank to system clipboard
zle-vimode-yank() {
    # normal vimode yank
    zle vi-yank

    # check if running inside an ssh session
    if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        # encode cutbuffer to base64 without line breaks
        local b64_text
        b64_text=$(echo -n "$CUTBUFFER" | base64 | tr -d '\r\n')
        # send osc 52 escape sequence to local terminal
        if [[ -n "$TMUX" ]]; then
            # wrap sequence for tmux passthrough
            printf "\033Ptmux;\033\033]52;c;%s\007\033\\" "$b64_text" > /dev/tty
        else
            printf "\033]52;c;%s\007" "$b64_text" > /dev/tty
        fi
    # otherwise copy to local clipboard manger
    elif installed wl-copy; then
        echo -n "$CUTBUFFER" | wl-copy
    elif installed termux-clipboard-set; then
        echo -n "$CUTBUFFER" | termux-clipboard-set
    fi
}
zle -N zle-vimode-yank
bindkey -M visual 'y' zle-vimode-yank

# less delay
KEYTIMEOUT=1

# Change cursor shape for different vi modes.
# ref: https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
# in zle-keymap-select, set '\e[{x} q', where {x} is:
# 0 = blinking block.
# 1 = blinking block (default).
# 2 = steady block.
# 3 = blinking underline.
# 4 = steady underline.
# 5 = blinking bar, xterm.
# 6 = steady bar, xterm.
zle-keymap-select() {
    # Executed every time the keymap changes, i.e. the special parameter KEYMAP is set to a different value, while the line editor is  active.   Initialising
    # the keymap when the line editor starts does not cause the widget to be called.
    #
    # The value $KEYMAP within the function reflects the new keymap.  The old keymap is passed as the sole argument.
    #
    # This can be used for detecting switches between the vi command (vicmd) and insert (usually main) keymaps.
    #
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

# register the new widget
zle -N zle-keymap-select

# executed just before a new prompt is displayed
precmd_functions+=(zle-keymap-select)
