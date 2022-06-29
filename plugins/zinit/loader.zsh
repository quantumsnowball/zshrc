# <my zinit plugins>
zinit snippet OMZP::git
zinit snippet OMZP::ssh-agent

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit ice depth=1
zinit light romkatv/powerlevel10k

# fzf
# Modified command to work with zsh-vi-mode plugins
zinit ice lucid wait
zinit snippet OMZP::fzf
# </my zinit plugins>
