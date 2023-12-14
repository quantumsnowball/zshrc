lf-gdrive () {
    # define vars
    root=gdrive
    target=$HOME/$root/$1

    # ensure dir
    mkdir -p $target

    # start mount
    rclone mount --daemon $1 $target &
    sleep 5

    # start browsing
    command lf $target

    # unmount when finished
    fusermount -u $target
}

alias lfg=lf-gdrive
