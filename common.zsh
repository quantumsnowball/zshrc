# check if binary exists in PATH
# to be used as a guarding statement, put at first line of a script file: 
#   ensure <binary name> || return
ensure () {
    command -v "$1" 2>&1 >/dev/null
}
