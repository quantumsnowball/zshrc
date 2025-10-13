# for PC use pyenv, virtualenv just for termux
[ -v TERMUX_VERSION ] || return

# auto activate this env
if [[ -f "$HOME/.python/virtualenv/python/bin/activate" ]]; then
    source "$HOME/.python/virtualenv/python/bin/activate"
fi

# NOTE:
# to install some package that was not available in pip in termux,
# e.g, numpy, scipy, torch, run:
#   pkg/apt install python-numpy python-scipy python-torch
#
# to create a new venv, run:
# (make sure include --system-site-packages flag to include pkg/apt packages)
#   virtualenv --system-site-packages ~/.python/virtualenv/<env-name>
#
# to install virtualenv, use pipx:
#   pipx install virtualenv
# to install pipx:
#   apt install pipx, or use python -m pip install --user pipx
# if system python refuse to install by pip, try create venv:
#   python -m venv ~/.python/venv/pipx
#   then install pipx using this venv's python
#   (may require --system-site-packages flag if no access)

