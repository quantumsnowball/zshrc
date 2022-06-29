# mkdir and then cd into it in one command
mkcd () { mkdir -p -- "$1" && cd -P -- "$1" }

