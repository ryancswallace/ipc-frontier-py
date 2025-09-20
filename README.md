# `ipc-frontier-py`

[![Build](https://github.com/ryancswallace/ipc-frontier-py/actions/workflows/ci.yaml/badge.svg)](https://github.com/ryancswallace/ipc-frontier-py/actions/workflows/ci.yaml)
[![Coverage](https://codecov.io/github/ryancswallace/ipc-frontier-py/branch/main/graph/badge.svg)](https://codecov.io/github/ryancswallace/ipc-frontier-py)
[![PyPI Version](https://img.shields.io/pypi/v/ipc-frontier-py.svg)](https://pypi.org/project/ipc-frontier-py/)
[![Docs Site](https://img.shields.io/badge/docs-GitHub_Pages-blue)](https://ryancswallace.github.io/ipc-frontier-py/)
[![Security Policy](https://img.shields.io/badge/security-policy-blue.svg)](https://github.com/ryancswallace/ipc-frontier-py/blob/main/SECURITY.md)
[![License](https://img.shields.io/github/license/ryancswallace/ipc-frontier-py.svg)](https://github.com/ryancswallace/ipc-frontier-py/blob/main/LICENSE)

---

**`ipc-frontier-py`** implements benchmarks comparing Python concurrency models--**threads**, **Queue-based multiprocessing**, and **SharedMemory-based multiprocessing**--for moving and processing NumPy arrays. The benchmarks highlight throughput, latency, and IPC overheads relevant to ML/AI data pipelines and performance-sensitive Python applications.

TODO

## 📝 Benchmark Analysis

For an analysis and discussion of the benchmark results, see the accompanying blog post ➡️ **[Benchmarking Python Concurrency Models for NumPy Array Operations](https://ryancswallace.dev/posts/python-numpy-concurrency-benchmarks/)**. ⬅️

The write-up interprets the benchmark data, compares concurrency mechanisms in practical terms, and draws lessons for
building efficient ML/AI workloads in Python.

## 📖 Documentation

The **[`ipc-frontier-py` documentation site](https://ryancswallace.github.io/ipc-frontier-py/)** provides a browsable and searchable reference for the package's modules, classes, and functions. Use the doc site to dig into both the package's public interfaces and its internal implementation details.

The site is automatically generated with [pdoc](https://pdoc.dev/) from the package’s source code docstrings. The static site contents are hosted on GitHub Pages. This site is built by the `pages` GitHub Actions workflow from the latest content of the `main` branch.

## 🛠️ Development

This section contains info about developing the `ipc_frontier` Python package itself.

> **First time working on the project?** Run `make install-tools` then `make setup`.

### Requirements

Supported on Linux and macOS.

### Contributing Code

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for the pull request process used to introduce code changes.

### Releases

See [`RELEASE.md`](./RELEASE.md) for a description of the GitHub pipeline that builds and publishes new versions of the `ipc_frontier` package.

### Tooling

The `ipc-frontier-py` project uses **Pyenv** for Python version management and **Poetry** for package management, environment management, and builds.

The `ipc-frontier-py` project uses **Make** to automate common development operations and workflows. Run `make help` or see the `Makefile` in the root of the repository for a full list of the available targets. See the "Make Targets" section below for guidance using selected targets.

### Make Targets

This section describes how and when to use the automated procedures for common development tasks.

#### `install-tools`

```sh
make install-tools
```

Installs the tools required to run other targets. Tools include Pyenv and Poetry. This target only needs to be run once per user.

#### `setup`

```sh
make setup
```

Creates an isolated execution environment to run the project. This target installs the required version of Python using Pyenv and creates a virtual environment using Poetry with the required dependencies plus the `ipc_frontier` package itself installed.

#### `fmt`

```sh
make fmt
```

Autoformats the entire codebase in compliance with the project's style standards. All formatting is handled by Ruff in a way that mimics the combination of Black + autopep8 + isort.

#### `test`

```sh
make test
```

Executes type checks and runs the suite of unit tests. Pyright is used for type checking, and pytest is used as the unit test framework.

#### `clean`

```sh
make clean
```

Deletes build/test/coverage artifacts, including `.pytest_cache/`, `.mypy_cache/`, and `.ruff_cache/`.
