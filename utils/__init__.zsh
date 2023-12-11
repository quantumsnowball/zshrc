source $HOME/.config/zshrc/utils/dir.zsh
source $HOME/.config/zshrc/utils/config.zsh
source $HOME/.config/zshrc/utils/zoxide.zsh
source $HOME/.config/zshrc/utils/python.zsh
source $HOME/.config/zshrc/utils/conda/__init__.zsh
source $HOME/.config/zshrc/utils/pip.zsh
source $HOME/.config/zshrc/utils/memory.zsh
source $HOME/.config/zshrc/utils/ffmpeg/__init__.zsh
source $HOME/.config/zshrc/utils/rclone.zsh
source $HOME/.config/zshrc/utils/youtube-dl.zsh
source $HOME/.config/zshrc/utils/docker.zsh
source $HOME/.config/zshrc/utils/eza.zsh
source $HOME/.config/zshrc/utils/git.zsh
source $HOME/.config/zshrc/utils/nvim.zsh
source $HOME/.config/zshrc/utils/iproute2.zsh
source $HOME/.config/zshrc/utils/tmux.zsh
source $HOME/.config/zshrc/utils/lazygit.zsh
source $HOME/.config/zshrc/utils/socket.zsh
if [ -f "/etc/arch-release" ]; then 
    source $HOME/.config/zshrc/utils/pacman.zsh
fi
