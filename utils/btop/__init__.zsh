ensure btop || return

btop.cpu-gpu() {
    CFG=$(mktemp /tmp/btop.cpu.XXXX.conf) &&
    cp ~/.config/zshrc/utils/btop/cpu_gpu.conf "$CFG" &&
    btop -c "$CFG"
}

