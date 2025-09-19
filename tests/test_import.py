"""Smoke tests for basic importability of the package."""

from __future__ import annotations


def test_package_imports() -> None:
    """Ensure the top-level package can be imported without errors.

    Notes
    -----
    Basic sanity check to guard against packaging or installation issues.
    """
    import ipc_frontier
    del ipc_frontier
