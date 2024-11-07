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

    # helpers
    conda-install-essentials () {
        # general
        conda install --yes click 
        conda install --yes ipython 
        conda install --yes jupyter 
        conda install --yes pytest
        # numeric
        conda install --yes numpy
        conda install --yes scipy 
        conda install --yes pandas
        # charting
        conda install --yes matplotlib
        # networking
        conda install --yes requests 
        conda install --yes aiohttp
        # linting
        conda install --yes mypy 
        conda install --yes isort
    }
fi
