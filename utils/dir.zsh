# mkdir and then cd into it in one command
mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1" 
}

# create a file with all intermediate directories
onetouch()
{
    mkdir -p $(dirname $1) && touch $1;
}
