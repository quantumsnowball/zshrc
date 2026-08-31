ensure git || return

# pager
export GIT_PAGER="less"

source $XDG_CONFIG_HOME/zshrc/utils/git/log.zsh
source $XDG_CONFIG_HOME/zshrc/utils/git/config.zsh
source $XDG_CONFIG_HOME/zshrc/utils/git/clone.zsh
