"""Console-script entry point wrapper for ipc_frontier."""

from __future__ import annotations

import sys

from .cli import main as cli_main


def main() -> int:
    """Main ipc-frontier benchmarking entrypoint."""
    return cli_main()


if __name__ == "__main__":
    sys.exit(main())
