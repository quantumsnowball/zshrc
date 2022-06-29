BASE=$HOME/.config/zshrc


source $BASE/zsh/init.zsh
source $BASE/zsh/env.zsh
source $BASE/zsh/commands.zsh
source $BASE/zsh/utils.zsh

source $BASE/plugins/zinit/init.zsh
source $BASE/plugins/zinit/loader.zsh
source $BASE/plugins/powerlevel10k/init.zsh

source $BASE/alias/init.zsh

# source $BASE/path/init.zsh

# <my path>
# homebrew
export PATH=/opt/homebrew/bin:$PATH
# yarn
export PATH=~/.yarn/bin:$PATH
# local
export PATH=~/.local/bin:$PATH
# .scripts
export PATH=~/.scripts:$PATH
# </my path>


# <my greeting>
# fortune | cow$(shuf -n1 -e say think) -f $(/bin/ls /opt/homebrew/Cellar/cowsay/3.04_1/share/cows | shuf -n1) | lolcat
# </my greeting>

