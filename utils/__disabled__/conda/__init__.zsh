ensure conda || return


alias conda.activate='conda activate'
alias condaa=conda.activate

alias conda.install='conda install'
alias condai=conda.install

conda.search () { conda search $1 | bat }
alias condas=conda.search

alias conda.ls='conda list | bat'
alias condals=conda.ls

alias conda.ls-grep='conda list | rg'
alias condarg=conda.ls-grep

alias conda.remove='conda remove'
alias condarm=conda.remove


alias conda.update='conda search --outdated'
alias condau=conda.update

alias conda.upgrade='conda upgrade --all'
alias condaup=conda.upgrade

alias conda.list-envs='conda env list'
alias condalsenv=conda.list-envs

conda.diff() { python $HOME/.config/zshrc/utils/conda/diff.py "$@" | bat }

# helpers
alias conda.install-basic='pip.install-basic'
