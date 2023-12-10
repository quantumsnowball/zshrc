zinit snippet OMZP::git
zinit snippet OMZP::ssh-agent

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicdreplay" \
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

# plugin related configs
# always starting with normal mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL
