# start up script
export PYTHONSTARTUP=$HOME/.config/zshrc/init/lib/pythonstartup.py

# inject smart breakpoint
export PYTHONPATH=$HOME/.config/zshrc/init/pythonpath:$PYTHONPATH
export PYTHONBREAKPOINT=smart_breakpoint.set_trace
