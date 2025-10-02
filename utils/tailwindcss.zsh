ensure pnpm || return

tw () {
    FORCE_COLOR=1 pnpx tailwindcss-document-cli "$1" | less -c -S -R
}
