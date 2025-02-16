# pager
#export PAGER="most"
ensure bat && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
ensure bat && export GIT_PAGER="bat"
# editor
ensure nvim && export EDITOR="nvim"
