ensure ssh || return


# helpers
alias ssh.my-authorized-keys='cat ~/.ssh/authorized_keys'
alias ssh.my-config='cat ~/.ssh/config'
alias ssh.my-public-key='cat ~/.ssh/*.pub'
alias ssh.reset-known-hosts='rm ~/.ssh/known_hosts'
ssh.touch-remote () {
    [ -f ~/.config/ssh/touch-remote ] || return 1
    . ~/.config/ssh/touch-remote $1
}
ssh.install-locally () {
    # must ensure downloaded the repo first
    [ -f ~/.config/ssh/install ] || {
        mkdir -p ~/.config && cd ~/.config
        gh.clone-my-repo -token ssh
    }
    # this create the necessary symlinks
    [ -f ~/.config/ssh/install ] && . ~/.config/ssh/install
}


# omz ssh-agent plugin should already started a ssh-agent process
# it should ask for password the first time


#
# put ssh-agent settings here
#

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
  SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
else
  SHORT_HOST="${HOST/.*/}"
fi


# sshd
[ -v TERMUX_VERSION ] && sshd
