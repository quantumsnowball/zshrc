import sys

import pudb
import pudb.remote


# custom breakpoint hook
def set_trace(
    *args,
    remote=False,
    **kwargs,
) -> None:
    '''
    remote=True: 
        launch a pudb remote debugger, accessable by telnet on terminal
        useful when debugging multiprocess program
    '''
    # choose the correct set_trace to use
    _set_trace = (
        pudb.remote.set_trace if remote else
        pudb._get_debugger().set_trace
    )
    # caller frame
    caller_frame = sys._getframe(1)
    # caller set_trace with the caller_frame, with all *args, **kwargs
    return _set_trace(caller_frame, *args, **kwargs)
