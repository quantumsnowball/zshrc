# Resize btrfs partition failed, how to rescue?

- When resize with KDE Partition Manager, it may fail
    - it needs to resize the partition as well as the filesystem metadata
    - if these two thing don't match, the drive is unusable kernel will refuse to boot and drop into emergency mode
- KDE Partition may failed to do the second part on a live linux USB distro for maybe permission reason
    - when trying to boot it failed, but don't panic
    - boot back to live distro
    - open a terminal
        - run `sudo btrfs check /dev/nvme0n1p1`, or whatever the path of the main os partition
            - it should show some error, saying `device size is smaller than total_bytes` or similar
            - this indicate a size mismatch
        - run `sudo btrfs rescue fix-device-size /dev/nvme0n1p1` or whatever the path of the main os partition
            - it should do it job to correct the metadata about the size of the partition
            - then reboot and the os should boot normally
