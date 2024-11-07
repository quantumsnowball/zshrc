if command -v conda &> /dev/null; then 
    alias condaa='conda activate'
    alias condai='conda install'
    condas () { conda search $1 | bat }
    alias condals='conda list | bat'
    alias condagrep='conda list | rg'
    alias condarg=condagrep
    alias condarm='conda remove'
    alias condau='conda upgrade --all'
    alias condaup=condau
    alias condaenvls='conda env list'
    condadiff() { python $HOME/.config/zshrc/utils/conda/diff.py "$@" | bat }

fi
