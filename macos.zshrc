#c<zsh settings>
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install

# write to .histfile immediately after enter
setopt INC_APPEND_HISTORY
# <zsh settings>

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})É%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


# <my zinit plugins>
#setopt promptsubst
#zinit wait lucid for \
#    OMZL::git.zsh \
#  atload"unalias grv" \
#    OMZP::git

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  OMZP::web-search
      
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit ice depth=1
zinit light romkatv/powerlevel10k

# For postponing loading `fzf`
zinit ice lucid wait
zinit snippet OMZP::fzf
# </my zinit plugins>


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# <my alias>
# clear
alias cl=clear

# reload shell
alias rl='exec zsh'

# exit
alias x=exit

# python
alias py=ptpython
alias ipy=ptipython

# exa as ls
alias ls='exa -F --icons'
alias  l='exa -F --icons'
alias la='exa -aF --icons'
alias lt='exa -aF -s time --reverse --icons'
alias ll='exa -aF -l -h --icons --grid'
alias lT='exa -aF -l -h --icons --tree --level=2'

# directory and files
#alias mv='mv -i'
#alias rm='rm -i'

# process
alias jobs='jobs -l'

# git
alias gts='git status -uall'
alias gtl='git log --oneline'

# dotfiles git
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dgts='dotgit status -uall'
alias dgtl='dotgit log --oneline'
alias dotlazygit='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# neovim
alias v='nvim'
alias vi='nvim'

# tmux
alias t="tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -t"

# docker
alias dc="docker-compose"
alias dk="docker"
alias dkr="docker run -it"
alias dks="docker start"
alias dka="docker attach"

# rclone
alias rc="rclone"
alias rclsr="rclone listremotes"
alias rcls="rclone ls"
alias rclsd="rclone lsd"
# </my alias>


# <my path>
# homebrew
export PATH=/opt/homebrew/bin:$PATH
# yarn
export PATH=~/.yarn/bin:$PATH
# local
export PATH=~/.local/bin:$PATH
# .scripts
export PATH=~/.scripts:$PATH
# </my path>


# <my greeting>
# fortune | cow$(shuf -n1 -e say think) -f $(/bin/ls /opt/homebrew/Cellar/cowsay/3.04_1/share/cows | shuf -n1) | lolcat
# </my greeting>


# <my commands>
# zoxide
eval "$(zoxide init zsh)"

# pager
#export PAGER="most"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
#
# </my commands>


