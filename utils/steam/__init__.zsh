installed steam || return


# reset steam
steam.reset() {
    pkill -e -f "steam|gamescope|wine"
}
alias steam.reset.the-division='steam.reset && pkill -e -f "ubi|upc|Ubisoft|division|anticheat"'
alias steam.reset.assetto-corsa='steam.reset && pkill -e -f "acs"'

# Update your .zshrc with this version
steam.linux.installed-games() {
    uv run $XDG_CONFIG_HOME/zshrc/utils/steam/linux.installed-games.py;
}
