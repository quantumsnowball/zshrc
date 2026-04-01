ensure atuin || return


# Termux doesn't have a hostname, it defaults to 'localhost', so manually make one for atuin
[ -v TERMUX_VERSION ] && export ATUIN_HOST_NAME="Termux"
# For WSL, better use the distro name as hostname to distinguish from the Win host's hostname
[ -v WSL_DISTRO_NAME ] && export ATUIN_HOST_NAME="$WSL_DISTRO_NAME"

# docs: https://docs.atuin.sh/cli/configuration/key-binding
# usage: eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
eval "$(atuin init zsh --disable-up-arrow)"

# binds
bindkey -M vicmd 'K' atuin-search-vicmd
bindkey -M vicmd 'J' atuin-search-viins
