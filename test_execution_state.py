#!/usr/bin/env python3
"""Tests that execution_results state is reset atomically between runs."""

import asyncio
import json
import time

import pytest

from cursor_mcp_server import (
    _fresh_execution_results,
    execution_results,
    handle_call_tool,
)


def _reset_global():
    execution_results.clear()
    execution_results.update(_fresh_execution_results())


@pytest.fixture(autouse=True)
def clean_state():
    _reset_global()
    yield
    _reset_global()


def test_fresh_execution_results_defaults():
    state = _fresh_execution_results()
    assert state["last_run_time"] is None
    assert state["last_output"] == ""
    assert state["error_count"] == 0
    assert state["linter_errors"] == []
    assert state["success"] is False


def test_fresh_execution_results_overrides():
    state = _fresh_execution_results(error_count=5, success=True)
    assert state["error_count"] == 5
    assert state["success"] is True
    assert state["last_output"] == ""


@pytest.mark.asyncio
async def test_stale_state_does_not_leak():
    """Simulate two consecutive runs; second run must not carry stale fields."""
    await handle_call_tool(
        "report_code_execution",
        {
            "output": "SyntaxError: invalid syntax",
            "error_count": 3,
            "success": False,
            "linter_errors": ["line 1: SyntaxError", "line 5: IndentationError", "line 9: NameError"],
        },
    )

    assert execution_results["error_count"] == 3
    assert len(execution_results["linter_errors"]) == 3

    await handle_call_tool(
        "report_code_execution",
        {
            "output": "All tests passed",
            "error_count": 0,
            "success": True,
        },
    )

    assert execution_results["error_count"] == 0
    assert execution_results["linter_errors"] == []
    assert execution_results["success"] is True
    assert execution_results["last_output"] == "All tests passed"


@pytest.mark.asyncio
async def test_state_fully_replaced_on_each_call():
    """Every field must reflect the latest call, not a merge of old + new."""
    await handle_call_tool(
        "report_code_execution",
        {
            "output": "fail",
            "error_count": 10,
            "success": False,
            "linter_errors": ["e1"],
        },
    )

    old_time = execution_results["last_run_time"]

    await handle_call_tool(
        "report_code_execution",
        {
            "output": "ok",
            "error_count": 0,
            "success": True,
        },
    )

    assert execution_results["last_run_time"] >= old_time
    assert execution_results["last_output"] == "ok"
    assert execution_results["error_count"] == 0
    assert execution_results["linter_errors"] == []
    assert execution_results["success"] is True
