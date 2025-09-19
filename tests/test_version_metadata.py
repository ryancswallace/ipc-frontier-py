"""Validate distribution version metadata."""

from __future__ import annotations

from importlib.metadata import PackageNotFoundError, version
from typing import Annotated, Final

from packaging.version import InvalidVersion, Version

DIST_NAME: Annotated[Final[str], "The project's PyPI/GitHub distribution name"] = "ipc-frontier-py"


def test_distribution_version_is_pep440() -> None:
    """Assert the installed distribution exposes a valid PEP 440 version.

    Raises
    ------
    AssertionError
        If the distribution is not installed in the current environment or if the version string is not PEP
        440-compliant.
    """
    try:
        version_str: str = version(DIST_NAME)
    except PackageNotFoundError as e:  # pragma: no cover - explicit failure path
        raise AssertionError(
            f"Distribution {DIST_NAME!r} not found in the active environment. "
            + "Ensure the package is installed (e.g., via Poetry) before running tests."
        ) from e

    try:
        _: Version = Version(version_str)
    except InvalidVersion as e:  # pragma: no cover - explicit failure path
        raise AssertionError(f"Version {version_str!r} is not PEP 440-compliant.") from e
