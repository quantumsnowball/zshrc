wtfis()
{
    echo -e "\n>_ command -v $1"
    command -v $1
    echo -e "\n>_ type -a $1"
    type -a $1
    echo -e "\n>_ whatis $1"
    whatis $1
    echo -e "\n"
}
