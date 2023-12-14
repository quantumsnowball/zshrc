lf-gdrive () {
    # define vars
    root=$HOME/gdrive
    target=$root/$1

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

    # clean up empty dir
    find $root -mindepth 1 -type d -empty -delete
}

alias lfg=lf-gdrive
