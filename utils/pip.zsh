ensure pip || return


alias pipi='pip install'
alias pipls='pip list | bat'
alias pipgrep='pip list | rg'
alias piprg=pipgrep
alias piprm='pip uninstall'
alias pipu='pip-upgrade-all'
alias pipup=pipu

# helpers
pip-upgrade-all() 
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

pip-install-basic()
{
# general
pip install --no-input click 
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
}
