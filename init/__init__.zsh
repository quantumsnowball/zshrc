# load all modules inside init/
for item in $HOME/.config/zshrc/init/*; do 
    # If it's a directory, source the __init__.zsh file inside it
    if [ -d $item ] && [ -f $item/__init__.zsh ]; then
        source $item/__init__.zsh;
    fi
    # If it's a non-index .zsh file, source it
    if [ -f $item ] && [[ $item == *.zsh ]] && [[ $item != *__init__.zsh ]]; then
        source $item
    fi
done
