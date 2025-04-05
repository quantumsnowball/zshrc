ensure pip || return


# install
alias pip.install='pip install'
alias pipi=pip.install

# install editable
alias pip.install.editable='pip install -e'
alias pipi.e=pip.install.editable

# install editable (strict mode)
# NOTE: pyright or other LSP may not able to discover normal eitable repo, then try strict mode editable
# - everytime you change a file, need to restart LSP to reflect
# - everytime you added new file or rename file, need to reinstall editable strict, then restart LSP
# PEP ref: https://setuptools.pypa.io/en/latest/userguide/development_mode.html
pip.install.editable-strict () { pip install -e $1 --config-settings editable_mode=strict }
alias pipi.e-strict=pip.install.editable-strict

# list
alias pip.ls='pip list | bat'
alias pipls=pip.ls

alias pip.ls-grep='pip list | rg'
alias piprg=pip.ls-grep

# remove
alias pip.remove='pip uninstall'
alias piprm=pip.remove

# update
alias pip.update='pip list --outdated'
alias pipu=pip.update

# helpers
pip.upgrade-all() 
{
# List outdated packages
outdated_packages=$(pip list --outdated)

# Check if there are any outdated packages
if [[ -z $outdated_packages ]]; then
  echo "\nNo outdated packages found\n"
  return
fi

# Display the outdated packages
echo "\nOutdated packages:\n"
echo "$outdated_packages"

# Prompt for user confirmation
echo "\n"
read -q "REPLY?Do you want to upgrade these packages? (y/[N]) "

echo

# Upgrade packages if confirmed
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "\nUpgrading packages..."
  echo

  # Extract the package names and upgrade each package
  echo "$outdated_packages" | awk '{print $1}' | xargs -n1 pip install --upgrade
else
  echo "\nPackage upgrade canceled\n"
fi
}
alias pip.upgrade=pip.upgrade-all
alias pipup=pip.upgrade

pip.install-basic()
{
# general
pip install --no-input click 
pip install --no-input colorama 
pip install --no-input ipython 
pip install --no-input jupyter 
pip install --no-input pytest
# numeric
pip install --no-input numpy
pip install --no-input scipy 
pip install --no-input pandas
# charting
pip install --no-input matplotlib
# networking
pip install --no-input requests 
pip install --no-input aiohttp
# linting
pip install --no-input mypy 
pip install --no-input isort
pip install --no-input autopep8
# debug
pip install --no-input pudb
pip install --no-input debugpy
}
