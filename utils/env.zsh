() {
    # namespaces
    local ns=(zsh sh shell env vars sys os)

    # env vars
    alias ${^ns}.env-vars='env | bat -l sh'
    alias ${^ns}.shell-vars='set | bat -l sh'
    alias ${^ns}.aliases='alias | bat -l sh'
    alias ${^ns}.paths='printf "%s\n" $path | bat -l python'
    alias ${^ns}.function-paths='printf "%s\n" $fpath | bat -l python'
    alias ${^ns}.exports='export | bat -l sh'
}
