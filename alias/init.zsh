# pacman
alias pm=pacman

# sudo
alias sudo='sudo '
# clear
alias cl=clear

# reload shell
alias rl='exec zsh'

# exit
alias x=exit

# python
alias py=ptpython
alias ipy=ptipython

# exa as ls
alias ls='exa -F --icons'
alias  l='exa -F --icons'
alias la='exa -aF --icons'
alias lt='exa -aF -s time --reverse --icons'
alias ll='exa -aF -l -h --icons --grid'
alias lT='exa -aF -l -h --icons --tree --level=2'

# directory and files
#alias mv='mv -i'
#alias rm='rm -i'

# process
alias jobs='jobs -l'

# git
alias gts='git status -uall'
alias gtl='git log --oneline'

# dotfiles git
alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dgts='dotgit status -uall'
alias dgtl='dotgit log --oneline'
alias dotlazygit='lazygit --git-dir .dotfiles --work-tree ~'

# neovim
alias vi='nvim'
alias v='nvim'

# tmux
alias t="tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -t"

# docker
alias dc="docker-compose"
alias dk="docker"
alias dkr="docker run -it"
alias dks="docker start"
alias dka="docker attach"

# rclone
alias rc="rclone"
alias rclsr="rclone listremotes"
alias rcls="rclone ls"
alias rclsd="rclone lsd"
