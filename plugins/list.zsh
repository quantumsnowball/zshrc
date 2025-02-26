zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \

# plugin related configs
# if termux android, starts in vim insert mode
# else, start in vim normal mode 
# [ -v TERMUX_VERSION ] || ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL

