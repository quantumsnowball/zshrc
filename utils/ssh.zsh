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
ssh.allow-agent-forwarding() {
    # setup agent directory
    local agent="$HOME/.ssh/agent"
    mkdir -p "$agent"
    chmod 700 "$agent"
    echo "Setting permissions on $agent to 700 ..."

    # check effective sshd runtime configuration
    if sudo sshd -T 2>/dev/null | grep -iq '^allowagentforwarding no'; then
        echo "Agent forwarding is disabled in sshd config, creating override ..."
        sudo mkdir -p /etc/ssh/sshd_config.d
        echo "AllowAgentForwarding yes" | sudo tee /etc/ssh/sshd_config.d/10-agent-forwarding.conf > /dev/null
        sudo systemctl reload sshd
        echo "Reloaded sshd service with agent forwarding enabled"
    else
        echo "Agent forwarding is already enabled in sshd"
    fi
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
    alias ${^ns}.allow-agent-forwarding='ssh.allow-agent-forwarding'
}
