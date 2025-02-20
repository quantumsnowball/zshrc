# env vars
alias zsh.env-vars='env | bat -l sh'
alias lsenv=zsh.env-vars
alias lsenvs=zsh.env-vars

alias zsh.shell-vars='set | bat -l sh'
alias lsvar=zsh.shell-vars
alias lsvars=zsh.shell-vars
alias lsenvall=zsh.shell-vars

alias zsh.aliases='alias | bat -l sh'
alias lsalias=zsh.aliases

alias zsh.paths='printf "%s\n" $path | bat -l python'
alias lspath=zsh.paths
alias lspaths=zsh.paths

alias zsh.function-paths='printf "%s\n" $fpath | bat -l python'
alias lsfpath=zsh.function-paths
alias lsfpaths=zsh.function-paths

alias zsh.exports='export | bat -l sh'
alias lsexport=zsh.exports
alias lsexports=zsh.exports
