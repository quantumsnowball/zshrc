ensure magick || return

alias magick.convert='magick convert'
alias magick.identify='magick identify'

magick.identify.verbose() {
    magick identify -verbose "$1" | less
}

