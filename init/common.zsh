# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# disable ctrl-d quitting shell directly, press 3 times to quit
setopt IGNORE_EOF

