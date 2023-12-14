lf-gdrive () {
    # define vars
    root=gdrive
    target=$HOME/$root/$1

    # ensure dir
    mkdir -p $target

    # start mount
    echo "Mounting $target ..."
    rclone mount --daemon $1 $target

    # start browsing
    command lf $target

    # unmount when finished
    fusermount -u $target
    echo "Unmounted: $target"
}

alias lfg=lf-gdrive
