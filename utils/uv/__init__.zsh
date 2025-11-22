ensure uv || return


# list python
alias uv.python.list='uv python list'
alias uvpyls=uv.python.list

# global tools
alias uv.tool.list='uv tool list --show-version-specifiers --show-with --show-extras --show-python'
alias uvtoolls=uv.tool.list
alias uv.tool.install='uv tool install'
alias uvtooli=uv.tool.install
alias uv.tool.install.editable='uv tool install -e'
alias uvtooli.e=uv.tool.install.editable
alias uv.tool.uninstall='uv tool uninstall'
alias uvtoolrm=uv.tool.uninstall

# venv
uv.venv.activate-local () {
    if [[ -f ./.venv/bin/activate ]]; then
        . ./.venv/bin/activate
    else
        echo "Error: ./.venv/bin/activate not found. No virtual environment activated."
    fi
}

# cache management
alias uv.cache.prune='uv cache prune'
alias uvprune=uv.cache.prune
uv.venv-info () {
    uv run $HOME/.config/zshrc/utils/uv/lib/venv-info.py
}
alias uv.disk-usage=uv.venv-info
uv.trace-hardlink() {
    (( $# == 1 )) || { echo "Usage: uv.trace-hardlink <path-to-file-in-uv-cache>" && return 1 }
    # args
    local file="$1"
    [[ -f "$file" ]] || { echo "File not found: $file" && return 1 }
    # check inode
    local inode=$(stat -c %i -- "$file")
    echo "inode: $inode"
    # locate the same inode
    find \
        $HOME/.cache/uv \
        $HOME/.local/share/uv/tools \
        $HOME/.uv/venv \
        $HOME/repos \
        -type f -links +1 -inum $inode
}
uv.cache.list-entries() {
    local cache="${UV_CACHE_DIR:-$HOME/.cache/uv}/archive-v0"
    [[ -d "$cache" ]] || { echo "no uv cache"; return 1 }
    for dir in "$cache"/*/(N); do
        # find wheel
        local wheel=($dir/**/*.dist-info/WHEEL(N))
        (( $#wheel )) || continue
        # get pkg name from the .dist-info directory
        local pkg="${${wheel[1]:h}:t}"          # removes trailing .dist-info
        pkg="${pkg%.dist-info}"                 # safety
        # get tag
        local tag=$(grep -m1 '^Tag:' "$wheel[1]" | cut -d' ' -f2-)
        # print
        printf '%-40s %-40s %s\n' "$pkg" "$tag" "${dir:t}"
    done | 
        sort -f -k1 |  # sort by pkg name
        less -c -S -R
}

# uv pip
alias uv.pip.install='uv pip install'
alias uv.pipi=uv.pip.install
alias uv.pip.install.editable='uv pip install -e'
alias uv.pipi.e=uv.pip.install.editable
alias uv.pip.remove='uv pip uninstall'
alias uv.piprm=uv.pip.remove
uv.pip.install-basic()
{
    # general
    uv pip install \
        click typer \
        rich colorama \
        ipython jupyter pytest
    # numeric
    uv pip install \
        numpy scipy pandas
    # charting
    uv pip install \
        matplotlib
    # networking
    uv pip install \
        requests aiohttp
    # linting
    uv pip install \
        mypy isort autopep8
    # debug
    uv pip install \
        pudb debugpy
}
