ensure eza || return


# eza as ls
# alias ezaf='eza -F always'
alias ezaf='eza -F=always'
alias ls='ezaf --icons'
alias  l='ezaf --icons'
alias la='ezaf -a --icons'
alias lt='ezaf -a -s time --reverse --icons'
alias ll='ezaf -a -l -h --icons'
alias lll='ezaf -a -l -h --icons --grid'
alias lT='ezaf -a -l -h --icons --tree --level=2'
