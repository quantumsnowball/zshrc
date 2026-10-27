# cache management
alias uv.cache.prune='uv cache prune'
alias uvprune=uv.cache.prune
uv.venv-info () {
    uv run $XDG_CONFIG_HOME/zshrc/utils/uv/venv-info.py
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
        local pkg="${${wheel[1]:h}:t}"
        pkg="${pkg%.dist-info}"
        # get tag
        local tag=$(grep -m1 '^Tag:' "$wheel[1]" | cut -d' ' -f2-)
        # print
        printf '%-40s %-40s %s\n' "$pkg" "$tag" "${dir:t}"
    done |
        sort -f -k1 |  # sort by pkg name
        less -c -S -R
}

