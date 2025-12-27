ensure zoxide || return


# zoxide
# alias z="__zoxide_z" # disabled: this breaks z <Tab> completion
alias zz="__zoxide_zi"
alias zl="z -"

# helper
z.win() {
    z "$(wslpath $1)"
}
