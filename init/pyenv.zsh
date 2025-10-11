# pyenv
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# default shell env
if [[ -z "$VIRTUAL_ENV" ]]; then
  pyenv activate python-3.13.8
fi

