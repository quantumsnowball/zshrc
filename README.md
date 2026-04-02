# zsh

## How zsh dot files work?
reference: <https://github.com/sambacha/dotfiles2>

![](https://github.com/sambacha/dotfiles2/blob/master/.github/interactive_vs_noninteractive.png?raw=true)

![](https://github.com/sambacha/dotfiles2/blob/master/.github/shell-startup.png?raw=true)

## Usage
- ~/.zshenv, for all scenario
    - runs for all four scenario
        - interactive login\
          SDDM desktop session, SSH
        - interactive non-login\
          Kitty, Alacritty, Konsole
        - non-interactive login\
          SSH direct run command on remote
        - non-interactive non-login\
          when program call a shell to run a script
    - suitable for setting up global env vars

- ~/.zprofile, exclusive for login shell\
    suitable for global env vars

- ~/.zshrc, exclusive for interactive shell\
    suitable for logics for interactive session


