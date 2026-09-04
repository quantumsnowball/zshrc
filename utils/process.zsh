() {
    # namespaces
    local ns=(ps proc process task shell sh sys os)

    # process tree info
    alias ${^ns}.process='ps -eHo pid,comm'
    alias ${^ns}.process-tree='pstree -p | bat'
    alias ${^ns}.process-search-and-highlight='ps.process | rg -B2 -A1'
}
