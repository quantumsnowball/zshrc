[[ -n "$WSL_DISTRO_NAME" ]] || return

# whoami
windows.whoami() {
    /mnt/c/Windows/System32/whoami.exe | awk -F'\\' '{print $2}' | tr -d '\r'
}

# common paths
export WINDOWS_C="/mnt/c";
export WINDOWS_WINDOWS="$WINDOWS_C/Windows";
export WINDOWS_USERS="$WINDOWS_C/Users";
export WINDOWS_HOME="$WINDOWS_USERS/$(windows.whoami)";
export WINDOWS_APPDATA="$WINDOWS_HOME/AppData";


