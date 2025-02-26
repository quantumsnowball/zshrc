# zsh-vi-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode


# The plugin will auto execute this zvm_after_lazy_keybindings function
zvm_after_lazy_keybindings() {
  empty_widget () { }
  zvm_define_widget empty_widget
  zvm_bindkey vicmd '/' empty_widget
  zvm_bindkey vicmd '?' empty_widget
}
