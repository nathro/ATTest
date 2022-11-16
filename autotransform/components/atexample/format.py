# AutoTransform
# Large scale, component based code modification library
#
# Licensed under the MIT License <http://opensource.org/licenses/MIT>
# SPDX-License-Identifier: MIT
# Copyright (c) 2022-present Nathan Rockenbach <http://github.com/nathro>

# @black_format

"""The implementation for the ScriptTransformer."""

from __future__ import annotations

import subprocess
from typing import ClassVar

from autotransform.batcher.base import Batch
from autotransform.event.debug import DebugEvent
from autotransform.event.handler import EventHandler
from autotransform.transformer.base import Transformer


class FormatTransformer(Transformer[None]):
    """A simple formatting Transformer.

    Attributes:
        line_length (optional, int): The maximum length of any lines. Defaults to 80.
    """

    line_length: int = 80

    name: ClassVar[str] = "format"

    def transform(self, _batch: Batch) -> None:
        """Runs black

        Args:
            _batch (Batch): The Batch being transformed. Unused.
        """

        event_handler = EventHandler.get()
        cmd = ["black", "-l", str(self.line_length)]
        proc = subprocess.run(
            cmd,
            capture_output=True,
            encoding="utf-8",
            check=False,
            timeout=3600,
        )
        if proc.stdout.strip() != "":
            event_handler.handle(DebugEvent({"message": f"STDOUT:\n{proc.stdout.strip()}"}))
        else:
            event_handler.handle(DebugEvent({"message": "No STDOUT"}))
        if proc.stderr.strip() != "":
            event_handler.handle(DebugEvent({"message": f"STDERR:\n{proc.stderr.strip()}"}))
        else:
            event_handler.handle(DebugEvent({"message": "No STDERR"}))
        proc.check_returncode()