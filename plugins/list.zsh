zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

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

# zsh-vi-mode
# The plugin will auto execute this zvm_after_lazy_keybindings function
zvm_after_lazy_keybindings() {
  empty_widget () { }
  zvm_define_widget empty_widget
  zvm_bindkey vicmd '/' empty_widget
  zvm_bindkey vicmd '?' empty_widget
}
