# load all modules inside paths/
for item in $HOME/.config/zshrc/paths/*; do 
    # If it's a non-index .zsh file, source it
    if [ -f $item ] && [[ $item == *.zsh ]] && [[ $item != *__init__.zsh ]]; then
        source $item
    fi
done


# remove some problematic windows path
export PATH=$(
    # unpack
    echo "$PATH" | tr ':' '\n' | 

    # exclude these lines
    grep -v 'Documents/PowerShell/poshrc/scripts$' | 
    
    # repack
    tr '\n' ':' | sed 's/:$//'
)
