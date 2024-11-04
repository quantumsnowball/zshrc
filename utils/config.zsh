# nvim editor config repos directly
cf ()
{
    # run in a subshell
    # - can retain current directory
    # - can avoid printing the & [1] <PID> and + done debug message 
    (
        pull ()
        {
            echo "$(
                echo "cf pull $1 started\n"
                sleep 5                    
                echo "cf pull $1 finished\n"
            )"
        }
        case $1 in
        pull)
            pull arg1 & 
            pull arg2 & 
            pull arg3 & 
            wait
            ;;
        esac
    )
}
