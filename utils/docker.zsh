ensure docker || return


# docker
# ls
docker.ls.images() { docker images "$@" }
docker.ls.containers() { docker ps -a "$@" }

# run
docker.run() { docker run "$@" }
docker.run-interactive() { docker run -it "$@" }

# cleanup
docker.cleanup.containers() { docker container prune "$@" }
docker.cleanup.images() { docker system prune -a "$@" }

# sys
docker.disk-usage() { docker system df "$@" }

# alias dk.start="docker start"
# alias dks=dk.start

# alias dk.attach="docker attach"
# alias dka=dk.attach

