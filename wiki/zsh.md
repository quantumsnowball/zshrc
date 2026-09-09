# Zsh Cheatsheet

## Common Checks

- Check if a string is empty or not defined	
    ```zsh
    if [[ -z $VARNAME ]];
    ```

- Check if a string is defined and not empty
    ```zsh
    if [[ -n $VARNAME ]];
    ```

- Check if a file exists
    ```zsh
    if [[ -f "filepath" ]];
    ```

- Check if a directory exists
    ```zsh
    if [[ -d "dirpath" ]]; 
    ```

- Check if a symbolic link exists
    ```zsh
    if [[ -L "symlinkpath" ]];
    ```

- Check if a shell option is set
    ```zsh
    if [[ -o OPTION_NAME ]];
    ```

- Check if two values are equal
    ```zsh
    if [[ $VAR1 = $VAR2 ]];
    ```

- Check if two values are different
    ```zsh
    if [[ $VAR1 != $VAR2 ]];
    ```

- Check if a number is greater than another	
    ```zsh
    if (( $VAR1 > $VAR2 ));
    ```

- Check if a number is smaller than another

    ```zsh
    if (( $VAR1 < $VAR2 ));
    ```

- Check if a command exits successfully (exit code 0)
    ```zsh
    if command arg1 arg2 ...
    ```
