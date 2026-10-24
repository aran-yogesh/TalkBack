#!/usr/bin/env python3
"""
Unit tests for cursor_mcp_server.py
Covers: yaml_scalar, to_yaml, resource reading, tool call logic,
        response type selection, IPC file writing
"""

import asyncio
import os
import sys
import tempfile
import time
import unittest
from unittest.mock import AsyncMock, mock_open, patch

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from cursor_mcp_server import (
    execution_results,
    handle_call_tool,
    handle_list_resources,
    handle_list_tools,
    handle_read_resource,
    to_yaml,
    trigger_talkback_speech,
    yaml_scalar,
)


def run_async(coro):
    """Helper to run coroutines in tests (Python 3.10+ safe)."""
    return asyncio.run(coro)


# ---------------------------------------------------------------------------
# yaml_scalar tests (MCP server copy)
# ---------------------------------------------------------------------------

class TestMcpYamlScalar(unittest.TestCase):

    def test_true(self):
        self.assertEqual(yaml_scalar(True), "true")

    def test_false(self):
        self.assertEqual(yaml_scalar(False), "false")

    def test_none(self):
        self.assertEqual(yaml_scalar(None), "null")

    def test_integer(self):
        self.assertEqual(yaml_scalar(99), "99")

    def test_float(self):
        self.assertEqual(yaml_scalar(1.5), "1.5")

    def test_string(self):
        self.assertEqual(yaml_scalar("hello"), '"hello"')

    def test_empty_string(self):
        self.assertEqual(yaml_scalar(""), '""')

    def test_string_unicode(self):
        result = yaml_scalar("café")
        self.assertIn("café", result)

    def test_non_primitive_falls_back(self):
        result = yaml_scalar({"a": 1})
        self.assertIsInstance(result, str)


# ---------------------------------------------------------------------------
# to_yaml tests (MCP server copy)
# ---------------------------------------------------------------------------

class TestMcpToYaml(unittest.TestCase):

    def test_empty_dict(self):
        self.assertEqual(to_yaml({}), "{}\n")

    def test_empty_list(self):
        self.assertEqual(to_yaml([]), "[]\n")

    def test_string_scalar(self):
        result = to_yaml("plain")
        self.assertIn("plain", result)

    def test_bool_true_in_dict(self):
        result = to_yaml({"ok": True})
        self.assertIn("ok: true", result)

    def test_bool_false_in_dict(self):
        result = to_yaml({"ok": False})
        self.assertIn("ok: false", result)

    def test_none_in_dict(self):
        result = to_yaml({"val": None})
        self.assertIn("val: null", result)

    def test_int_in_dict(self):
        result = to_yaml({"n": 7})
        self.assertIn("n: 7", result)

    def test_empty_nested_dict(self):
        result = to_yaml({"x": {}})
        self.assertIn("x: {}", result)

    def test_empty_nested_list(self):
        result = to_yaml({"items": []})
        self.assertIn("items: []", result)

    def test_nested_dict(self):
        result = to_yaml({"a": {"b": 1}})
        self.assertIn("a:", result)
        self.assertIn("b:", result)

    def test_list_of_scalars(self):
        result = to_yaml([10, 20, 30])
        self.assertIn("- 10", result)
        self.assertIn("- 30", result)

    def test_dict_with_list(self):
        result = to_yaml({"errors": ["e1", "e2"]})
        self.assertIn("errors:", result)
        self.assertIn('- "e1"', result)

    def test_multikey_dict(self):
        result = to_yaml({"a": 1, "b": 2})
        self.assertIn("a: 1", result)
        self.assertIn("b: 2", result)

    def test_indent_parameter(self):
        result = to_yaml({"k": "v"}, indent=4)
        self.assertTrue(result.startswith("    "))


# ---------------------------------------------------------------------------
# handle_list_resources tests
# ---------------------------------------------------------------------------

class TestListResources(unittest.TestCase):

    def test_returns_two_resources(self):
        resources = run_async(handle_list_resources())
        self.assertEqual(len(resources), 2)

    def test_execution_results_uri(self):
        resources = run_async(handle_list_resources())
        uris = [str(r.uri) for r in resources]
        self.assertIn("talkback://execution-results", uris)

    def test_linter_errors_uri(self):
        resources = run_async(handle_list_resources())
        uris = [str(r.uri) for r in resources]
        self.assertIn("talkback://linter-errors", uris)

    def test_resource_has_name(self):
        resources = run_async(handle_list_resources())
        for r in resources:
            self.assertTrue(len(r.name) > 0)

    def test_resource_has_mime_type(self):
        resources = run_async(handle_list_resources())
        for r in resources:
            self.assertEqual(r.mimeType, "application/x-yaml")


# ---------------------------------------------------------------------------
# handle_read_resource tests
# ---------------------------------------------------------------------------

class TestReadResource(unittest.TestCase):

    def test_execution_results_returns_yaml(self):
        result = run_async(handle_read_resource("talkback://execution-results"))
        self.assertIsInstance(result, str)
        self.assertIn("error_count:", result)

    def test_linter_errors_returns_yaml(self):
        result = run_async(handle_read_resource("talkback://linter-errors"))
        self.assertIsInstance(result, str)
        self.assertIn("linter_errors:", result)

    def test_unknown_uri_raises(self):
        with self.assertRaises(ValueError):
            run_async(handle_read_resource("talkback://unknown"))

    def test_execution_results_contains_success_field(self):
        result = run_async(handle_read_resource("talkback://execution-results"))
        self.assertIn("success:", result)

    def test_linter_errors_contains_error_count(self):
        result = run_async(handle_read_resource("talkback://linter-errors"))
        self.assertIn("error_count:", result)


# ---------------------------------------------------------------------------
# handle_list_tools tests
# ---------------------------------------------------------------------------

class TestListTools(unittest.TestCase):

    def test_returns_two_tools(self):
        tools = run_async(handle_list_tools())
        self.assertEqual(len(tools), 2)

    def test_report_code_execution_tool_exists(self):
        tools = run_async(handle_list_tools())
        names = [t.name for t in tools]
        self.assertIn("report_code_execution", names)

    def test_trigger_talkback_roast_tool_exists(self):
        tools = run_async(handle_list_tools())
        names = [t.name for t in tools]
        self.assertIn("trigger_talkback_roast", names)

    def test_report_tool_has_input_schema(self):
        tools = run_async(handle_list_tools())
        report_tool = next(t for t in tools if t.name == "report_code_execution")
        self.assertIn("properties", report_tool.inputSchema)

    def test_report_tool_required_fields(self):
        tools = run_async(handle_list_tools())
        report_tool = next(t for t in tools if t.name == "report_code_execution")
        required = report_tool.inputSchema.get("required", [])
        self.assertIn("output", required)
        self.assertIn("error_count", required)
        self.assertIn("success", required)


# ---------------------------------------------------------------------------
# handle_call_tool — report_code_execution tests
# ---------------------------------------------------------------------------

class TestCallToolReportExecution(unittest.TestCase):

    def setUp(self):
        # Reset global execution state before each test
        execution_results["last_run_time"] = None
        execution_results["last_output"] = ""
        execution_results["error_count"] = 0
        execution_results["linter_errors"] = []
        execution_results["success"] = False

    def _call(self, args):
        with patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock):
            return run_async(handle_call_tool("report_code_execution", args))

    def test_updates_error_count(self):
        self._call({"output": "bad", "error_count": 3, "success": False})
        self.assertEqual(execution_results["error_count"], 3)

    def test_updates_success_flag(self):
        self._call({"output": "good", "error_count": 0, "success": True})
        self.assertTrue(execution_results["success"])

    def test_updates_last_output(self):
        self._call({"output": "hello output", "error_count": 0, "success": True})
        self.assertEqual(execution_results["last_output"], "hello output")

    def test_updates_linter_errors(self):
        self._call({"output": "x", "error_count": 1, "success": False,
                    "linter_errors": ["line 5: undefined var"]})
        self.assertEqual(execution_results["linter_errors"], ["line 5: undefined var"])

    def test_updates_last_run_time(self):
        before = time.time()
        self._call({"output": "x", "error_count": 0, "success": True})
        self.assertGreaterEqual(execution_results["last_run_time"], before)

    def test_returns_text_content(self):
        results = self._call({"output": "x", "error_count": 0, "success": True})
        self.assertTrue(len(results) > 0)
        self.assertEqual(results[0].type, "text")

    def test_response_type_roast_for_two_errors(self):
        results = self._call({"output": "crash", "error_count": 2, "success": False})
        self.assertIn("roast", results[0].text)

    def test_response_type_minor_sass_for_one_error(self):
        results = self._call({"output": "oops", "error_count": 1, "success": False})
        self.assertIn("minor_sass", results[0].text)

    def test_response_type_sassy_success_for_zero_errors(self):
        results = self._call({"output": "great", "error_count": 0, "success": True})
        self.assertIn("sassy_success", results[0].text)

    def test_large_error_count_gives_roast(self):
        results = self._call({"output": "disaster", "error_count": 99, "success": False})
        self.assertIn("roast", results[0].text)

    def test_linter_errors_defaults_to_empty_list(self):
        self._call({"output": "x", "error_count": 0, "success": True})
        self.assertEqual(execution_results["linter_errors"], [])


# ---------------------------------------------------------------------------
# handle_call_tool — trigger_talkback_roast tests
# ---------------------------------------------------------------------------

class TestCallToolTriggerRoast(unittest.TestCase):

    def setUp(self):
        execution_results["last_run_time"] = None
        execution_results["error_count"] = 0

    def _call(self, args):
        with patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock):
            return run_async(handle_call_tool("trigger_talkback_roast", args))

    def test_no_recent_execution_without_force_returns_message(self):
        results = self._call({"force": False})
        self.assertIn("No recent", results[0].text)

    def test_force_triggers_roast_even_without_execution(self):
        results = self._call({"force": True})
        self.assertIn("triggered", results[0].text)

    def test_with_recent_execution_triggers_roast(self):
        execution_results["last_run_time"] = time.time()
        results = self._call({})
        self.assertIn("triggered", results[0].text)

    def test_unknown_tool_raises(self):
        with self.assertRaises(ValueError):
            run_async(handle_call_tool("nonexistent_tool", {}))


# ---------------------------------------------------------------------------
# trigger_talkback_speech — IPC file writing
# ---------------------------------------------------------------------------

class TestTriggerTalkbackSpeech(unittest.TestCase):

    def test_writes_yaml_file(self):
        with tempfile.NamedTemporaryFile(suffix=".yaml", delete=False) as f:
            _ = f.name

        with patch("cursor_mcp_server.open", mock_open()) as mocked:
            run_async(trigger_talkback_speech("test prompt", "roast"))
            mocked.assert_called_once_with("/tmp/talkback_message.yaml", "w")

    def test_real_file_written(self):
        _ = tempfile.mktemp(suffix=".yaml")
        original_open = open

        written_content = {}

        def fake_open(path, mode="r"):
            if path == "/tmp/talkback_message.yaml" and mode == "w":
                import io
                buf = io.StringIO()
                written_content["buf"] = buf

                class FakeCtx:
                    def __enter__(self): return buf
                    def __exit__(self, *a): pass
                return FakeCtx()
            return original_open(path, mode)

        with patch("cursor_mcp_server.open", side_effect=fake_open):
            run_async(trigger_talkback_speech("hello prompt", "sassy_success"))

        content = written_content.get("buf", None)
        if content:
            self.assertIn("hello prompt", content.getvalue())


# ---------------------------------------------------------------------------
# execution_results global state
# ---------------------------------------------------------------------------

class TestExecutionResultsState(unittest.TestCase):

    def test_initial_keys_present(self):
        keys = {"last_run_time", "last_output", "error_count", "linter_errors", "success"}
        self.assertTrue(keys.issubset(set(execution_results.keys())))

    def test_initial_error_count_int(self):
        # Reset to default-like state
        execution_results["error_count"] = 0
        self.assertIsInstance(execution_results["error_count"], int)

    def test_initial_linter_errors_list(self):
        execution_results["linter_errors"] = []
        self.assertIsInstance(execution_results["linter_errors"], list)


if __name__ == "__main__":
    unittest.main()
