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

