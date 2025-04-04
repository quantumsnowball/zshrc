# auto activate this env
if [[ -n "$TERMUX_VERSION" && -d "$HOME/.venv/py-venv/bin" ]]; then
    source "$HOME/.venv/py-venv/bin/activate"
fi

# NOTE:
# to install some package that was not available in pip in termux,
# e.g, numpy, scipy, torch, run:
#   pkg/apt install python-numpy python-scipy python-torch
#
# to create a new venv, run:
# (make sure include --system-site-packages flag to include pkg/apt packages)
#   python -m venv --system-site-packages ~/.venv/py-venv

