ensure eza || return


# eza as ls
alias _eza_base='eza --classify=always --icons=always'
alias ls=_eza_base
alias  l=_eza_base
alias la='_eza_base -a'
alias lt='_eza_base -a -s time --reverse'
alias ll='_eza_base -a -l -h'
alias lll='_eza_base -a -l -h --grid'
alias ltree='_eza_base --tree --level=2'
