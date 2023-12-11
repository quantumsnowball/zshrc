wtfis()
{
    echo -e "\nwhich $1:"
    which $1
    echo -e "\ntype $1:"
    type $1
    echo -e "\nwhatis $1:"
    whatis $1
    echo -e "\n"
}
