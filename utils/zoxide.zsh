# zoxide
# alias z="__zoxide_z" # disabled: this breaks z <Tab> completion
alias zz="__zoxide_zi"
alias Z="__zoxide_zi"
alias zl="z -"


# z then v
zv() {
  z $1 && nvim;
}
