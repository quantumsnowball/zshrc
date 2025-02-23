if [ -v TERMUX_VERSION ]; then
    # source $HOME/.config/zshrc/utils/keychain/termux.zsh
    echo load termux.zsh instead
    return
fi

source $HOME/.config/zshrc/utils/keychain/default.zsh
