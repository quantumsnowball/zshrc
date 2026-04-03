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

# ls tree
alias ls.tree='la --tree'
alias ls.tree1='la --tree --level=1'
alias ls.tree2='la --tree --level=2'
alias ls.tree3='la --tree --level=3'
alias ls.tree4='la --tree --level=4'
alias ls.tree5='la --tree --level=5'
