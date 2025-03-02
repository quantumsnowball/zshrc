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

# init
autoload -Uz compinit
compinit

