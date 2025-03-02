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

# details
zstyle ':completion:*' complete-options true

# init
autoload -Uz compinit
compinit

