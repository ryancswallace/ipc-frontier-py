"""Basic tests for the __main__ module."""

from __future__ import annotations

from ipc_frontier.__main__ import main


def test_main() -> None:
    """Ensure __main__'s entry point exits cleanly."""
    assert main() == 0
