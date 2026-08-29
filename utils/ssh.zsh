ensure ssh || return


# helpers
alias ssh.my-authorized-keys='cat ~/.ssh/authorized_keys'
alias ssh.my-config='cat ~/.ssh/config'
# alias ssh.my-public-key='cat ~/.ssh/*.pub'
ssh.my-public-key() {
    echo ""
    for f in ~/.ssh/*.pub; do
        echo $YELLOW$(basename "$f")$RESET
        cat "$f"
        echo ""
    done
}
alias ssh.reset-known-hosts='rm ~/.ssh/known_hosts'
ssh.touch-remote () {
    [ -f ~/.config/workspace-private/ssh/touch-remote] || return 1
    . ~/.config/workspace-private/ssh/touch-remote $1
}
