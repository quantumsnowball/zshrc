# zmodload zsh/zprof

source $HOME/.config/zshrc/common.zsh
source $HOME/.config/zshrc/paths/__init__.zsh
source $HOME/.config/zshrc/init/__init__.zsh
source $HOME/.config/zshrc/plugins/__init__.zsh
source $HOME/.config/zshrc/utils/__init__.zsh
source $HOME/.config/zshrc/theme/p10k.zsh

[[ $ZSH_RELOADING == true ]] && echo "INFO: zsh reloaded" && unset ZSH_RELOADING || true
[[ $ZSH_RESOURCING == true ]] && echo "INFO: ~/.zshrc reloaded" && unset ZSH_RESOURCING || true

# zprof
