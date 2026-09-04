ensure eza || return


# eza common setting ground
alias _eza_base='eza --classify=always --icons=always'

# ls basic
alias ls=_eza_base
alias  l=_eza_base

# ls all
alias la='_eza_base -a'

# ls last modified 
alias lt='_eza_base -a -s time --reverse'

# ls long
alias ll='_eza_base -a -l -h'
alias lll='_eza_base -a -l -h --grid'

() {
    # namespaces
    local ns=(ls dir directory file fs)

    # ls all
    alias ${^ns}.list-all='la'

    # ls last modified 
    alias ${^ns}.list-last-modified='lt'

    # ls long
    alias ${^ns}.list-long='ll'
    alias ${^ns}.list-long-grid='lll'

    # ls tree
    alias ${^ns}.tree='la --tree'
    alias ${^ns}.tree1='la --tree --level=1'
    alias ${^ns}.tree2='la --tree --level=2'
    alias ${^ns}.tree3='la --tree --level=3'
    alias ${^ns}.tree4='la --tree --level=4'
    alias ${^ns}.tree5='la --tree --level=5'
}
