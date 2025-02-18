# env vars
alias zsh.ls-env-vars='env | bat -l sh'
alias lsenv=zsh.ls-env-vars
alias lsenvs=zsh.ls-env-vars

alias zsh.ls-shell-vars='set | bat -l sh'
alias lsvar=zsh.ls-shell-vars
alias lsvars=zsh.ls-shell-vars
alias lsenvall=zsh.ls-shell-vars

alias zsh.ls-aliases='alias | bat -l sh'
alias lsalias=zsh.ls-aliases

alias zsh.ls-paths='printf "%s\n" $path | bat -l python'
alias lspath=zsh.ls-paths
alias lspaths=zsh.ls-paths

alias zsh.ls-function-paths='printf "%s\n" $fpath | bat -l python'
alias lsfpath=zsh.ls-function-paths
alias lsfpaths=zsh.ls-function-paths

alias zsh.ls-exports='export | bat -l sh'
alias lsexport=zsh.ls-exports
alias lsexports=zsh.ls-exports
