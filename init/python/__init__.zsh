# start up script
export PYTHONSTARTUP=$HOME/.config/zshrc/init/python/pythonstartup.py

# inject smart breakpoint
export PYTHONPATH=$HOME/.config/zshrc/init/python/pythonpath:$PYTHONPATH
export PYTHONBREAKPOINT=smart_breakpoint.set_trace
