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
    [ -f ~/.config/ssh/touch-remote ] || return 1
    . ~/.config/ssh/touch-remote $1
}
ssh.install-locally () {
    # must ensure downloaded the repo first
    [ -f ~/.config/ssh/install ] || {(
        mkdir -p ~/.config && cd ~/.config
        gh.clone-my-repo -token ssh
    )}
    # this create the necessary symlinks
    [ -f ~/.config/ssh/install ] && . ~/.config/ssh/install
}
ssh.uninstall-locally () {
    # uninstall the symlinks and restore a real file
    cp ~/.config/ssh/authorized_keys ~/.ssh/authorized_keys.real &&
    mv ~/.ssh/authorized_keys.real ~/.ssh/authorized_keys

    cp ~/.config/ssh/config ~/.ssh/config.real &&
    mv ~/.ssh/config.real ~/.ssh/config
}
ssh.status () {
    local dst=~/.ssh/authorized_keys
    [ -f $dst ] || { 
        echo "\n[ FAILED ]\nFile $dst does not exists.\nHost may not be reachable via SSH.\n"
        return 1
    }
    [ -L ~/.ssh/authorized_keys ] || {
        echo "\n[ FAILED ]\nFile $dst is static.\nIt may need to manually updated to enable more hosts.\n"
        return 1
    }
    local src=$(readlink -f $dst)
    local correct_src="$HOME/.config/ssh/authorized_keys"
    [ $src = $correct_src ] || {
        echo "\n[ FAILED ]\nFile $dst is wrongly linked to $src.\nRun ssh.install-locally again may fix it.\n"
        return 1
    }
    echo "\n[ SUCCESS ]\nFile $dst is linked correctly to $correct_src.\n"
    return 0    
}


