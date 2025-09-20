"""Command line interface for ipc_frontier.

Provides the `main` entry point. Handles argument parsing and generating pretty output.
"""

from __future__ import annotations


def main() -> int:
    """CLI entry point.

    Parameters
    ----------
    argv : Sequence[str] or None, optional
        Argument vector to parse. If `None`, arguments are taken from `sys.argv`.

    Returns
    -------
    int
        Process exit code: `0` on success, non-zero on error.
    """
    print("cli.main()")  # TODO

    return 0
