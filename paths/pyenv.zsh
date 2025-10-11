# pyenv
# note: 
#   2025-10-11 08:48:33 installed pyenv using shell script, uninstalled the pacman version which is outdated
#   now pyenv app bin is installed in ~/.pyenv this is the github repo that is most updated
#   add to path and use pyenv just for compiling the latest python version is good use case
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
