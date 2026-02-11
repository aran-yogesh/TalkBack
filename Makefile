.PHONY: help install format lint check

help:
	@echo "Available targets:"
	@echo "  make install  - Install dev dependencies (ruff)"
	@echo "  make format   - Auto-format code and fix lint issues"
	@echo "  make lint     - Check for lint errors and formatting issues"
	@echo "  make check    - Run format then lint"

install:
	pip install -r requirements-dev.txt

format:
	ruff format .
	ruff check --fix .

lint:
	ruff check .
	ruff format --check .

check: format lint
