ensure docker || return


# docker
# ls
alias docker.ls.containers='docker ps -a'
alias docker.ls.images='docker images -a'
alias docker.ls.images-tree='docker images -a --tree'

# interact
alias docker.run='docker run'
alias docker.run-interactive='docker run -it'
alias docker.attach='docker attach'

# cleanup
alias docker.cleanup.containers='docker container prune'
alias docker.cleanup.system='docker system prune'

# sys
alias docker.disk-usage='docker system df'
