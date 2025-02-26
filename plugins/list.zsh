zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \

# diff-so-fancy
zinit ice lucid as"program" pick"bin/git-dsf"
zinit load so-fancy/diff-so-fancy

# fzf
# Modified command to work with zsh-vi-mode plugins
zinit ice lucid wait
ensure fzf && zinit snippet OMZP::fzf

# plugin related configs
# if termux android, starts in vim insert mode
# else, start in vim normal mode 
# [ -v TERMUX_VERSION ] || ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL

