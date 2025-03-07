# shell reloaded confirmation
[[ $ZSH_RELOADING == true ]] && echo "INFO: zsh reloaded" && unset ZSH_RELOADING || true
[[ $ZSH_RESOURCING == true ]] && echo "INFO: ~/.zshrc reloaded" && unset ZSH_RESOURCING || true
