.PHONY: format lint format-python lint-python install-tools

PYTHON_FILES := broken_code.py cursor_mcp_server.py cursor_code_monitor.py test_mcp_connection.py

install-tools:
	pip install ruff

format: format-python

format-python:
	ruff format $(PYTHON_FILES)

lint: lint-python

lint-python:
	ruff check $(PYTHON_FILES)
