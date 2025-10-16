[[ -n "$WSL_DISTRO_NAME" ]] || return

# whoami
windows.whoami() {
    /mnt/c/Windows/System32/whoami.exe | awk -F'\\' '{print $2}' | tr -d '\r'
}

# system
export WINDOWS_C="/mnt/c";
export WINDOWS_WINDOWS="$WINDOWS_C/Windows";

# users
export WINDOWS_USERS="$WINDOWS_C/Users";
export WINDOWS_HOME="$WINDOWS_USERS/$(windows.whoami)";
export WINDOWS_APPDATA="$WINDOWS_HOME/AppData";
export WINDOWS_DOCUMENTS="$WINDOWS_HOME/Documents";
export WINDOWS_DOWNLOADS="$WINDOWS_HOME/Downloads";
export WINDOWS_PICTURES="$WINDOWS_HOME/Pictures";
export WINDOWS_VIDEOS="$WINDOWS_HOME/Videos";
export WINDOWS_CAPTURES="$WINDOWS_VIDEOS/Captures";

# programs
export WINDOWS_PROGRAM_FILES="$WINDOWS_C/Program Files"
export WINDOWS_PROGRAM_FILES_X86="$WINDOWS_C/Program Files (x86)"
export WINDOWS_PROGRAMDATA="$WINDOWS_C/ProgramData"
export WINDOWS_START_MENU_PROGRAMS="$WINDOWS_APPDATA/Roaming/Microsoft/Windows/Start Menu/Programs"
export WINDOWS_STARTUP="$WINDOWS_START_MENU_PROGRAMS/Startup"

# steams
export WINDOWS_STEAMAPPS="$WINDOWS_PROGRAM_FILES_X86/Steam/steamapps/common"
