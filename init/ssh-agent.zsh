#
# This is a modified version of the om-my-zsh ssh-agent plugins
# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/ssh-agent/ssh-agent.plugin.zsh
#

# Get the filename to store/lookup the environment from
ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

function ssh-agent.start() {
  # ensure environment present
  if [[ -f "$ssh_env_cache" ]]; then
    . "$ssh_env_cache" > /dev/null

    # if socket is also visible then ssh-agent is ready, nicely exit
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  # if ssh-agent not ready, proceed to recreate it

  # first ensure ~/.ssh/ directory
  if [[ ! -d "$HOME/.ssh" ]]; then
    echo "ssh-agent requires ~/.ssh directory"
    return 1
  fi

  # start ssh-agent ps and cache the setup environment script
  echo "Starting ssh-agent ..."
  ssh-agent -s | sed '/^echo/d' >! "$ssh_env_cache"

  # execute the script to create the environment
  chmod 600 "$ssh_env_cache"
  . "$ssh_env_cache" > /dev/null
}

function ssh-agent.add-keys() {
  # check for .ssh folder presence
  if [[ ! -d "$HOME/.ssh" ]]; then
    echo "ssh-agent requires ~/.ssh directory"
    return 1
  fi

  # this will auto discover and add keys
  ssh-add
}

# init
ssh-agent.start

# cleanup
unset ssh_env_cache

