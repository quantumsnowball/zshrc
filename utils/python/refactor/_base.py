from abc import ABC
from pathlib import Path

import libcst as cst


class Transformer(cst.CSTTransformer, ABC):
    def __init__(self, current_path: Path, max_dots: int):
        self.current_path = current_path
        self.max_dots = max_dots
