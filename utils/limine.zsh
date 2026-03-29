installed limine || return


# set limine boot loader wallpaper
# note:
# in /boot/limine.conf, add these lines at the top global session:
#   term_font_scale: 2x2
#   wallpaper: boot():/EFI/limine/wallpaper.jpg
#   wallpaper_style: stretched
limine.use-wallpaper() {
    local src="$1"
    local dst="/boot/EFI/limine/wallpaper.jpg"
    local tmp_img="/tmp/limine_wallpaper_tmp.jpg"

    if [[ ! -f "$src" ]]; then
        echo "Error: File '$src' not found."
        return 1
    fi

    echo "Processing wallpaper..."

    # Check ratio and Inner Crop (Center Gravity)
    # We use -shave or -extent via a centered gravity to force the 2560:1080 aspect ratio
    # Target ~1MB size using jpeg:extent
    if magick "$src" -gravity center -extent 2560:1080 -define jpeg:extent=2048kb "$tmp_img"; then
        
        # Copy to destination
        echo "Copying to $dst (requires sudo)..."
        sudo cp "$tmp_img" "$dst"
        
        # Cleanup
        rm "$tmp_img"
        echo "Success! Wallpaper updated."
    else
        echo "Error: Image processing failed. Make sure 'magick' is installed."
        [[ -f "$tmp_img" ]] && rm "$tmp_img"
        return 1
    fi
}

