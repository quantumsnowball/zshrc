ensure docker || return


# docker
alias dc="docker-compose"
alias dk="docker"

alias dk.run-interactive="docker run -it"
alias dkr=dk.run-interactive

alias dk.start="docker start"
alias dks=dk.start

alias dk.attach="docker attach"
alias dka=dk.attach

alias dk.ls-container="docker ps -a"
alias dkps=ls-container
