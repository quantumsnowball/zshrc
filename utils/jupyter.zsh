# wsl2 may not be able to launch the default browser
# causing jupyter server to stuck in the launch
# start jupyter server with '--no-browser' flag will dirty fix this problem
alias jlab='jupyter lab --no-browser'
alias jnotebook='jupyter notebook --no-browser'
