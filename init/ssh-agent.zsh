#
# This is a modified version of the om-my-zsh ssh-agent plugins
# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/ssh-agent/ssh-agent.plugin.zsh
#

# Get the filename to store/lookup the environment from
ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

function ssh-agent.start() {
  # Check if ssh-agent is already running
  if [[ -f "$ssh_env_cache" ]]; then
    . "$ssh_env_cache" > /dev/null

    # Test if $SSH_AUTH_SOCK is visible
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  if [[ ! -d "$HOME/.ssh" ]]; then
    echo "[oh-my-zsh] ssh-agent plugin requires ~/.ssh directory"
    return 1
  fi

  # start ssh-agent and setup environment
  echo "Starting ssh-agent ..."
  ssh-agent -s | sed '/^echo/d' >! "$ssh_env_cache"
  chmod 600 "$ssh_env_cache"
  . "$ssh_env_cache" > /dev/null
}

function ssh-agent.add-keys() {
  local id file line sig lines
  local -a identities loaded_sigs loaded_ids not_loaded
  zstyle -a :omz:plugins:ssh-agent identities identities

  # check for .ssh folder presence
  if [[ ! -d "$HOME/.ssh" ]]; then
    return
  fi

  # add default keys if no identities were set up via zstyle
  # this is to mimic the call to ssh-add with no identities
  if [[ ${#identities} -eq 0 ]]; then
    # key list found on `ssh-add` man page's DESCRIPTION section
    for id in id_rsa id_dsa id_ecdsa id_ed25519 id_ed25519_sk identity; do
      # check if file exists
      [[ -f "$HOME/.ssh/$id" ]] && identities+=($id)
    done
  fi

  # get list of loaded identities' signatures and filenames
  if lines=$(ssh-add -l); then
    for line in ${(f)lines}; do
      loaded_sigs+=${${(z)line}[2]}
      loaded_ids+=${${(z)line}[3]}
    done
  fi

  # add identities if not already loaded
  for id in $identities; do
    # if id is an absolute path, make file equal to id
    [[ "$id" = /* ]] && file="$id" || file="$HOME/.ssh/$id"
    # check for filename match, otherwise try for signature match
    if [[ -f $file && ${loaded_ids[(I)$file]} -le 0 ]]; then
      sig="$(ssh-keygen -lf "$file" | awk '{print $2}')"
      [[ ${loaded_sigs[(I)$sig]} -le 0 ]] && not_loaded+=("$file")
    fi
  done

  # abort if no identities need to be loaded
  if [[ ${#not_loaded} -eq 0 ]]; then
    return
  fi

  # pass extra arguments to ssh-add
  local args
  zstyle -a :omz:plugins:ssh-agent ssh-add-args args

  # if ssh-agent quiet mode, pass -q to ssh-add
  zstyle -t :omz:plugins:ssh-agent quiet && args=(-q $args)

  # use user specified helper to ask for password (ksshaskpass, etc)
  local helper
  zstyle -s :omz:plugins:ssh-agent helper helper

  if [[ -n "$helper" ]]; then
    if [[ -z "${commands[$helper]}" ]]; then
      echo >&2 "ssh-agent: the helper '$helper' has not been found."
    else
      SSH_ASKPASS="$helper" ssh-add "${args[@]}" ${^not_loaded} < /dev/null
      return $?
    fi
  fi

  ssh-add "${args[@]}" ${^not_loaded}
}

# init
ssh-agent.start

# cleanup
unset ssh_env_cache

