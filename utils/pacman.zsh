# pacman
if command -v pacman &> /dev/null; then 
    alias pm=pacman
    alias pmi='sudo pm -S'
    alias pms='pm -Ss'
    alias pmls='pm -Q'
    alias pmgrep='pm -Q | rg'
    alias pmrg=pmgrep
    alias pmrm='sudo pm -R'
    alias pmu='sudo pm -Sy && pm -Qu'
    alias pmup='sudo pm -Syu'
fi

