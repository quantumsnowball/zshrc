ensure uv || return


# list python
alias uv.python.list='uv python list'
alias uvpyls=uv.python.list

# list global tools
alias uv.tool.list='uv tool list --show-version-specifiers --show-with --show-extras --show-python'
alias uvtoolls=uv.tool.list

# venv
uv.venv.activate-local () {
    if [[ -f ./.venv/bin/activate ]]; then
        . ./.venv/bin/activate
    else
        echo "Error: ./.venv/bin/activate not found. No virtual environment activated."
    fi
}

# disk usage
uv.disk-usage () {
    echo "=== Real uv disk usage ==="
    
    # Cache
    echo "Cache (real wheels + extracted files):"
    du -sh ~/.cache/uv || echo "cache is empty"
    
    # tools
    echo -e "\nHard-linked tools environments:"
    fd -u -t d -d 1 . ~/.local/share/uv/tools -X du -sh --apparent-size | sort -h

    # user envs
    echo -e "\nHard-linked user environments:"
    fd -u -t d -d 1 . ~/.uv/venv -X du -sh --apparent-size | sort -h
    
    # project envs under repos
    echo -e "\nProject .venv directories:"
    fd -u -t d '^\.venv$' ~/repos -X du -sh --apparent-size | sort -h
}
