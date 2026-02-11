.PHONY: format lint check

format:
	ruff format .
	ruff check --fix .

lint:
	ruff check .
	ruff format --check .

check: format lint
