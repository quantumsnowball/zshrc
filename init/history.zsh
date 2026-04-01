# The path to your history file
HISTFILE=$HOME/.zsh_history

# Max number of commands kept in the internal list
HISTSIZE=10000000

# Max number of commands saved in the history file
SAVEHIST=10000000

# Save the time the command was started and the duration
setopt EXTENDED_HISTORY

# Immediately append to the history file, don't wait for the shell to exit
setopt INC_APPEND_HISTORY 

# Share history between all open terminal sessions
setopt SHARE_HISTORY
