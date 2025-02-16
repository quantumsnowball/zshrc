installed batcat || return


# batcat
installed bat || {
    mkdir -p ~/.local/bin/
    ln -s -f $(which batcat) ~/.local/bin/bat
}
