from abc import ABC
from pathlib import Path
from typing import Callable

import libcst as cst


class Transformer(cst.CSTTransformer, ABC):
    def __init__(self, current_path: Path):
        self.current_path = current_path


TransformerFactory = Callable[[Path, ], Transformer]
