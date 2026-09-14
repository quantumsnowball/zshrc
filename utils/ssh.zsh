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

# sync ssh authorized_keys and config to a remote host
ssh.touch-remote () {
    # check for missing target host or help flags
    if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
        echo "usage: sync_ssh <ssh-hostname> [key|config]"
        return 1
    fi

    local host="$1"
    local mode="$2"

    case "$mode" in
        key|keys)
            # fix local file permissions before transfer
            chmod 600 "$HOME/.ssh/authorized_keys"
            scp "$HOME/.ssh/authorized_keys" "$host:~/.ssh/authorized_keys"
            ;;
        config|configs)
            # fix local file permissions before transfer
            chmod 600 "$HOME/.ssh/config"
            scp "$HOME/.ssh/config" "$host:~/.ssh/config"
            ;;
        *)
            # fix local file permissions before transfer
            chmod 600 "$HOME/.ssh/authorized_keys" "$HOME/.ssh/config"
            scp "$HOME/.ssh/authorized_keys" "$host:~/.ssh/authorized_keys"
            scp "$HOME/.ssh/config" "$host:~/.ssh/config"
            ;;
    esac
}

# enable agent forwarding
ssh.allow_agent_forwarding() {
    # ~/.ssh/agent/ directory must have permission to write and execute
    local agent="$HOME/.ssh/agent/"
    mkdir -p "$agent"
    chmod 700 "$agent"
    # if some distro disabled agent forward by default
    # run `grep -i AllowAgentForwarding /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*` to confirm
    # add an overriding file to sshd_config.d/
    # echo "AllowAgentForwarding yes" | sudo tee /etc/ssh/sshd_config.d/10-agent-forwarding.conf > /dev/null
    # restart the sshd service
    sudo systemctl restart sshd
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
