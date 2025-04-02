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
alias ltree='_eza_base --tree --level=2'
alias ltr=ltree
