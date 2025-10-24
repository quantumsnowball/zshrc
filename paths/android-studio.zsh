installed android-studio || return

export ANDROID_HOME="$HOME/Android/Sdk"
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin/:$ANDROID_HOME/platform-tools/
