# constant
export gh=https://github.com
export myghname=quantumsnowball
export mygh=$gh/$myghname
export myghssh=git@github.com:$myghname


ensure git || return

# pager
export GIT_PAGER="less"

# git log
source $XDG_CONFIG_HOME/zshrc/utils/git/log.zsh

# config
source $XDG_CONFIG_HOME/zshrc/utils/git/config.zsh

# clone
source $XDG_CONFIG_HOME/zshrc/utils/git/clone.zsh
