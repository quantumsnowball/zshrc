installed steam || return


# reset steam
alias steam.reset='pkill -e -f "steam|gamescope|steamvr"'
alias steam.reset.division='steam.reset && pkill -e -f "ubi|Ubisoft|division|anticheat"'
alias steam.reset.assetto-corsa='steam.reset && pkill -e -f "acs"'

# Update your .zshrc with this version
steam.linux.installed-games() {
    local steam_dirs=(
        "$HOME/.local/share/Steam/steamapps"
        # "$HOME/.steam/steam/steamapps"
        # "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps"
    )

    # Use a subshell to collect and sort output
    (
        for dir in $steam_dirs; do
            [[ -d "$dir" ]] || continue
            
            for manifest in "$dir"/appmanifest_*.acf(N); do
                local appid=${${manifest##*/appmanifest_}%.acf}
                # Extract name, removing potential trailing whitespace
                local name=$(grep -Po '"name"\s+"\K[^"]+' "$manifest")
                
                # Output Name followed by AppID, separated by a unique delimiter for sorting
                printf "%s|%s\n" "$name" "$appid"
            done
        done
    ) | sort -f | while IFS='|' read -r name appid; do
        # Format the final output: Name (Left-aligned) | AppID (Right-aligned)
        printf "%-50s | %s\n" "$name" "$appid"
    done
}

# 
# Games
#

# Division 2
games.division2() { 
    # need to ensure sub-process see wayland display env
    mangohud steam -silent -applaunch 2221490
}

# Assetto Corsa
games.assetto-corsa() { steam -silent -applaunch 244210 }

# No Man's Sky
games.no-mans-sky() { steam -silent -applaunch 275850 -nointro }
