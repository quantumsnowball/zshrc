ensure keychain || return


if [ -v TERMUX_VERSION ]; then
    source $HOME/.config/zshrc/utils/keychain/termux.zsh
    return
fi

source $HOME/.config/zshrc/utils/keychain/default.zsh
