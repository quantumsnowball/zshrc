# process tree info
alias ps.process='ps -eHo pid,comm'
alias lsps=ps.process
alias ps.process-tree='pstree -p | bat'
alias lsps2=ps.process-tree
alias ps.highlight='lsps | rg -B2 -A1'
alias findps=ps.highlight
