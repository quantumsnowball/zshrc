ensure usbtree || return


alias usbtree='sudo modprobe usbmon 2>/dev/null; sudo -E usbtree --nerd-font'
