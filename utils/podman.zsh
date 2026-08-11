ensure podman || return


# podman
# ls
alias podman.ls.containers='podman ps -a'
alias podman.ls.images='podman images -a'
alias podman.ls.images-tree='podman images -a --tree'
alias podman.ls.volumes='podman volume ls'

# interact
alias podman.run='podman run'
alias podman.run-interactive='podman run -it'
alias podman.start='podman start'
alias podman.stop='podman stop'
alias podman.attach='podman start -ai'

# remove
alias podman.rm.image='podman rmi'
alias podman.rm.container='podman rm'

# cleanup
alias podman.cleanup.containers='podman container prune'
alias podman.cleanup.system='podman system prune'

# sys
alias podman.disk-usage='podman system df'
