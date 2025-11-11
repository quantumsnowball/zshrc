from ffprobe_streams.result import Result


def present(r: Result) -> None:
    # subject line
    print(f"\n\t< ffprobe: total {r.nb_streams} stream(s) >\n",)
    # present streams
    # for s in r.streams:
    #     if isinstance()
