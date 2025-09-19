"""Shared pytest configuration and fixtures for ipc_frontier tests."""

from __future__ import annotations

import pytest


@pytest.fixture(autouse=True)
def _pin_blas_threads(monkeypatch: pytest.MonkeyPatch) -> None:  # pyright: ignore[reportUnusedFunction]
    """Pin BLAS/OpenMP thread counts for reproducible test runs.

    This fixture is applied automatically to all tests (`autouse=True`). It limits implicit parallelism from numeric
    libraries so that timing and resource usage are stable and comparable across environments.

    Parameters
    ----------
    monkeypatch : pytest.MonkeyPatch
        Pytest fixture used to set required environment variables.
    """
    monkeypatch.setenv("OMP_NUM_THREADS", "1")
    monkeypatch.setenv("MKL_NUM_THREADS", "1")
    monkeypatch.setenv("OPENBLAS_NUM_THREADS", "1")
