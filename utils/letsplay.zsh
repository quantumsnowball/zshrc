installed letsplay || return


# Division 2
letsplay.division2() { 
    letsplay steam 2221490 --mangohud --launch-options 'PROTON_ENABLE_WAYLAND=1 %command'
}

# Assetto Corsa
letsplay.assetto-corsa() {
    letsplay steam 244210 --launch-options 'c="%command%"; sh -c "${c::-17}Content Manager Safe.exe'\''"'
}

# No Man's Sky
letsplay.no-mans-sky() {
    letsplay steam 275850 --mangohud --launch-options '-nointro'
}

# Euro Truck Simulator 2
letsplay.euro-truck-simulator-2() {
    letsplay steam 227300 --mangohud --launch-options '-nointro'
}
