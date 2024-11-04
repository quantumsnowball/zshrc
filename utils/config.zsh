# nvim editor config repos directly
cf ()
{
    # run in a subshell
    # - can retain current directory
    # - can avoid printing the & [1] <PID> and + done debug message 
    (
        status ()
        {
            echo "$(
                echo "\n# $1\n#\n" &&
                cd ~/.config/$1 &&
                git -c color.ui=always status --short --branch 2>&1
            )"
        }
        pull ()
        {
            echo "$(
                echo "\n# $1\n#\n" &&
                cd ~/.config/$1 &&
                git -c color.ui=always pull --rebase --autostash 2>&1
            )"
        }


        case $1 in
        status)
            status settings & 
            status zshrc & 
            status nvim & 
            status tmux & 
            wait
            ;;
        pull)
            pull settings & 
            pull zshrc & 
            pull nvim & 
            pull tmux & 
            wait
            ;;
        esac
    )
}
