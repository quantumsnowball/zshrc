# Usage:
#   zstyle <pattern> <style> <values>
# pattern: 
#   :completion:<function>:<completer>:<command>:<argument>:<tag>    

# completion to fpath
fpath=(~/.config/zshrc/completions/functions/ $fpath)

# rc
zstyle :compinstall filename "$HOME/.zshrc"

# colors
eval "$(dircolors)"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# menu
setopt globdots
zstyle ':completion:*' menu yes select
zstyle ':completion:*:*:*:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases functions builtins commands
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '\e' send-break
bindkey -M menuselect 'q' send-break

# details
zstyle ':completion:*' complete-options true

# 
# matcher
#
# case insenstive match, substring match
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# init
autoload -Uz compinit
compinit


