if command -v pip &> /dev/null; then 
  alias pip-update-all=pip-upgrade-all

  pip-install-basic()
  {
    pip install \
      numpy pandas matplotlib scipy \
      ipython jupyter \
      requests aiohttp \
      click \
      pytest \
      mypy \
      autopep8 isort
  }

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
fi
