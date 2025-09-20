"""Tests for the command line interface implementation in the cli module."""

from __future__ import annotations

from ipc_frontier.cli import main


def test_main() -> None:
    """Ensure the cli module entry point exits cleanly."""
    assert main() == 0
