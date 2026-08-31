# load all modules inside utitls/
for item in $HOME/.config/zshrc/utils/*; do 
    # If it's a directory, source the __init__.zsh file inside it
    if [ -d $item ] && [ -f $item/__init__.zsh ]; then
        source $item/__init__.zsh;
    fi
    # If it's a non-index .zsh file, source it
    if [ -f $item ] && [[ $item == *.zsh ]] && [[ $item != *__init__.zsh ]]; then
        source $item
    fi
done

# manually add external source here
items=(
    $XDG_CONFIG_HOME/workspace-private/keepass/script/__init__.zsh
    $XDG_CONFIG_HOME/workspace-private/rclone/script/__init__.zsh
)
for item in $items; do 
    if [ -f $item ]; then
        source $item
    fi
done

