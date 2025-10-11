ensure pyenv || return

alias pyenv.activate='pyenv activate'
alias pyenva='pyenv.activate'

alias pyenv.python.available='pyenv install --list'
pyenv.python.available.search () { pyenv install --list | rg "$1" }
alias pyenv.python.installed.binary='pyenv versions --bare --skip-envs --skip-aliases'
alias pyenv.python.installed.all='pyenv versions'

alias pyenv.which='pyenv which'

alias pyenv.venv.create='pyenv virtualenv'
alias pyenvmk='pyenv.venv.create'

alias pyenv.venv.ls='pyenv virtualenvs --bare --skip-aliases'
alias pyenvls='pyenv.venv.ls'

alias pyenv.venv.rm='pyenv virtualenv-delete'
alias pyenvrm='pyenv.venv.rm'
