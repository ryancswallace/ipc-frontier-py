# Project constants
PACKAGE := ipc_frontier
PYTHON_VERSION := 3.13.7
PACKAGE_DIR := "$(PACKAGE)/"
TEST_DIR := tests/
CLEAN_PRUNE_DIRS := .git .venv
DOCS_SITE_DIR := site/

# Executables
PYENV ?= pyenv
POETRY ?= poetry
GIT ?= git
PRINT ?= printf
PYTHON := python

# Python configurations
export PYTHONNOUSERSITE := 1
unexport PYTHONPATH

# User shell configurations
SHELL_RC ?= $$HOME/.zshrc

# Define variable for slash to prevent linter from accidentally interpreting double slashes as comments
SLASH := /
DOUBLESLASH := $(SLASH)$(SLASH)

# GitHub URL
GH_USER_CONTENT_ROOT_URL := https:$(DOUBLESLASH)raw.githubusercontent.com/ryancswallace/ipc-frontier-py/refs/heads/main

# Targets
.PHONY: help
help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: all
all: ## Install tools, setup project runtime, format code, run tests, and clean repo
all: install-tools setup fmt test clean changes

.PHONY: prerelease
prerelease: ## Setup project runtime, format code, run tests, and clean repo
prerelease: setup fmt test clean changes

.PHONY: install-tools
install-tools: ## Install Pyenv and Poetry
install-tools: install-pyenv install-poetry

.PHONY: install-pyenv
install-pyenv:
	@if [ -d "$$HOME/.pyenv" ]; then \
		echo "==> Updating existing Pyenv..."; \
		cd "$$HOME/.pyenv" && git pull origin master; \
	else \
		echo "==> Installing Pyenv..."; \
		$(GIT) clone https:$(DOUBLESLASH)github.com/pyenv/pyenv.git "$$HOME/.pyenv"; \
	fi; \
	echo 'export PYENV_ROOT="$$HOME/.pyenv"' >> "$(SHELL_RC)"; \
	echo 'export PATH="$$PYENV_ROOT/bin:$$PATH"' >> "$(SHELL_RC)"; \
	echo 'eval "$$(pyenv init -)"' >> "$(SHELL_RC)"
	@printf "\n\033[91mIMPORTANT NOTE:\033[0m If this is your first time installing Pyenv, you must source your shell's RC file to make Poetry accessible in your current terminal .\n"

.PHONY: install-poetry
install-poetry:
	@curl -sSL https:$(DOUBLESLASH)install.python-poetry.org | /usr/bin/python3
	@echo 'export PATH="$$PATH:~/.local/bin"' >> "$(SHELL_RC)"
	@printf "\n\033[91mIMPORTANT NOTE:\033[0m If this is your first time installing Poetry, you must source your shell's RC file to make Poetry accessible in your current terminal.\n"

.PHONY: init
init:  ## ONE-TIME, INTERACTIVE project Pyenv and Poetry setup
	$(PYENV) local $(PYTHON_VERSION)
	$(POETRY) init

.PHONY: setup
setup:  ## Download Python, then create a Poetry environment and install the package
	TMPDIR="${HOME}/tmp" $(PYENV) install --skip-existing $$(cat .python-version) \
	&& $(POETRY) config virtualenvs.in-project true \
	&& $(POETRY) env use $$($(PYENV) which python) \
	&& $(POETRY) install --all-groups --no-interaction

.PHONY: fmt
fmt: ## Apply auto code formatting and linting.
	$(POETRY) run ruff check . --fix
	$(POETRY) run ruff format .

.PHONY: fmttest
fmttest: ## Test whether code is formatted correctly.
	$(POETRY) run ruff check .

.PHONY: typetest
typetest: ## Run type checks.
	$(POETRY) run pyright $(PACKAGE_DIR) $(TEST_DIR)

.PHONY: unittest
unittest: ## Run unit tests and end-to-end tests.
	$(POETRY) run pytest

.PHONY: test
test: ## Run all tests: type tests, unit tests, and end-to-end tests.
test: typetest unittest

.PHONY: docs
docs: ## Use pdoc to generate a static documentation site.
	$(POETRY) run pdoc $(PACKAGE) \
		-o $(DOCS_SITE_DIR) \
		--footer-text "$$($(POETRY) version)" \
		--docformat numpy \
		--favicon "$(GH_USER_CONTENT_ROOT_URL)/docs/assets/favicon.ico" \
		--logo "$(GH_USER_CONTENT_ROOT_URL)/docs/assets/logo.svg" \
		--math \
		--search \
		--show-source

.PHONY: clean
clean: ## Delete build/test/coverage artifacts.
	@find . \
	  $(foreach d,$(PRUNE_DIRS),-path './$(d)' -prune -o) \
	  \( \
	    -name '__pycache__' -o \
	    -name '.pytest_cache' -o \
	    -name '.mypy_cache' -o \
	    -name '.ruff_cache' -o \
	    -name 'htmlcov' -o \
	    -name 'build' -o \
	    -name 'dist' -o \
	    -name '*.egg-info' -o \
	    -name '.coverage' -o \
	    -name '.coverage.*' -o \
	    -name 'coverage.xml' -o \
	    -name '*.pyc' -o \
	    -name '*.pyo' -o \
	    -name 'site' \
	  \) -exec rm -rf -- {} +

.PHONY: changes
changes: ## Check for uncommitted changes.
	@$(GIT) status --porcelain=v1 2>/dev/null | grep -q '.*' \
	&& { $(PRINT) "\nFAILED: Uncommitted changes. Changes to docs or formatting?\n"; exit 1; } \
	|| { $(PRINT) "\nSUCCESS: Ready to release.\n"; exit 0; }
