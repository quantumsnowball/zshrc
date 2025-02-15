# docker
if command -v docker &> /dev/null; then
    alias dc="docker-compose"
    alias dk="docker"
    alias dkr="docker run -it"
    alias dks="docker start"
    alias dka="docker attach"
    alias dkps="docker ps -a | most"
fi
