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
    find $root -mindepth 1 -maxdepth 1 -type d -empty -delete
}

# Define lf-gdrive-cleanup function
lf-gdrive-cleanup() {
    root=$HOME/gdrive
    # Unmount all mount points under ~/gdrive
    find $root -maxdepth 1 -mindepth 1 -type d -exec sh -c '
        mount_point="$0"
        fusermount -u "$mount_point"
        echo "Unmounted $mount_point"
    ' {} \;
  
    # Remove empty directories under ~/gdrive
    find $root -mindepth 1 -maxdepth 1 -type d -empty -delete
    # Check if there are any directories left inside ~/gdrive
    if [[ -z $(find ~/gdrive -mindepth 1 -maxdepth 1 -type d) ]]; then
        echo "Cleanup completed."
    else
        echo "Cleanup failed. Some directories still exist within ~/gdrive."
    fi
}

alias lfg=lf-gdrive
