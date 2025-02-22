#
# This is a modified version of the om-my-zsh ssh-agent plugins
# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/ssh-agent/ssh-agent.plugin.zsh
#

# don't load anything if missing ~/.ssh/ 
 [ -d "$HOME/.ssh" ] || return


# helpers
alias ssh-agent.ls-added-keys='ssh-add -l'
alias sshls=ssh-agent.ls-added-keys

alias ssh-agent.kill='killall ssh-agent'
alias sshkill=ssh-agent.kill
alias sshlock=ssh-agent.kill

# this will auto discover and add keys
alias ssh-agent.add-keys='ssh-add'
alias ssha=ssh-agent.add-keys

function ssh-agent.start() {
  # ensure environment present
  if [[ -f ~/.ssh/.env ]]; then
    . ~/.ssh/.env > /dev/null

    # if socket is also visible then ssh-agent is ready, nicely exit
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  # if ssh-agent not ready, proceed to recreate it

  # start ssh-agent ps and cache the setup environment script
  echo "Starting ssh-agent ..."
  ssh-agent -s | sed '/^echo/d' >! ~/.ssh/.env

  # execute the script to create the environment
  chmod 600 ~/.ssh/.env
  . ~/.ssh/.env > /dev/null
}

# ensure started ssh-agent on shell launch
ssh-agent.start
