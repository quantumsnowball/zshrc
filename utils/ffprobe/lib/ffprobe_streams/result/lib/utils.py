def hms(total_seconds: float) -> str:
    hours = int(total_seconds // 3600)
    remaining_seconds_after_hours = total_seconds % 3600
    minutes = int(remaining_seconds_after_hours // 60)
    seconds = int(remaining_seconds_after_hours % 60)
    hms = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
    return hms
