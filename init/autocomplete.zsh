# Usage:
#   zstyle <pattern> <style> <values>
# pattern: 
#   :completion:<function>:<completer>:<command>:<argument>:<tag>    

# rc
zstyle :compinstall filename "$HOME/.zshrc"

# colors
zstyle ':completion:*' list-colors ''

# menu
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# details
zstyle ':completion:*' complete-options true

# init
autoload -Uz compinit
compinit

