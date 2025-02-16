ensure ssh || return


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
