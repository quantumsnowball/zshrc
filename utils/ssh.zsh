ensure ssh || return


# alias ssh.my-public-key='cat ~/.ssh/*.pub'
ssh.my-public-keys() {
    echo ""
    for f in ~/.ssh/*.pub; do
        echo $YELLOW$(basename "$f")$RESET
        cat "$f"
        echo ""
    done
}
ssh.touch-remote () {
    [ -f ~/.config/workspace-private/ssh/touch-remote] || return 1
    . ~/.config/workspace-private/ssh/touch-remote $1
}

() {
    # namespaces
    local ns=(ssh sshd scp sftp keychain kc)

    # helpers
    alias ${^ns}.list-added-keys='ssh-add -l'
    alias ${^ns}.list-public-keys='ssh.my-public-keys'
    alias ${^ns}.list-authorized-keys='cat ~/.ssh/authorized_keys'
    alias ${^ns}.list-ssh-config='cat ~/.ssh/config'
    alias ${^ns}.reset-known-hosts='rm ~/.ssh/known_hosts'
    alias ${^ns}.touch-remote='ssh.touch-remote'
}
