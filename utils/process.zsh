# process tree info
alias lsps='ps -eHo pid,comm'
alias lsps2='pstree -p | bat'
alias findps='lsps | rg -B2 -A1'
