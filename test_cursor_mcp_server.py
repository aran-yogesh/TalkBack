#!/usr/bin/env python3
"""Tests for cursor_mcp_server.py"""

import asyncio
import json
import os
import sys
import tempfile
import time
import types as builtin_types
import unittest
from unittest.mock import patch, AsyncMock, MagicMock

mcp_mod = builtin_types.ModuleType("mcp")
mcp_types = builtin_types.ModuleType("mcp.types")
mcp_server_mod = builtin_types.ModuleType("mcp.server")
mcp_server_models = builtin_types.ModuleType("mcp.server.models")
mcp_server_stdio = builtin_types.ModuleType("mcp.server.stdio")


class _FakeResource:
    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)


class _FakeTool:
    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)


class _FakeTextContent:
    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)


mcp_types.Resource = _FakeResource
mcp_types.Tool = _FakeTool
mcp_types.TextContent = _FakeTextContent
mcp_types.ImageContent = type("ImageContent", (), {})
mcp_types.EmbeddedResource = type("EmbeddedResource", (), {})


class _FakeServer:
    def __init__(self, name):
        self.name = name
        self._handlers = {}

    def list_resources(self):
        def decorator(fn):
            self._handlers["list_resources"] = fn
            return fn
        return decorator

    def read_resource(self):
        def decorator(fn):
            self._handlers["read_resource"] = fn
            return fn
        return decorator

    def list_tools(self):
        def decorator(fn):
            self._handlers["list_tools"] = fn
            return fn
        return decorator

    def call_tool(self):
        def decorator(fn):
            self._handlers["call_tool"] = fn
            return fn
        return decorator

    def get_capabilities(self, **kwargs):
        return {}

    async def run(self, *args, **kwargs):
        pass


mcp_server_mod.Server = _FakeServer
mcp_server_mod.NotificationOptions = type(
    "NotificationOptions", (), {"__init__": lambda self, **kw: None}
)
mcp_server_models.InitializationOptions = type(
    "InitializationOptions", (), {"__init__": lambda self, **kw: None}
)
mcp_server_stdio.stdio_server = MagicMock

sys.modules.setdefault("mcp", mcp_mod)
sys.modules.setdefault("mcp.types", mcp_types)
sys.modules.setdefault("mcp.server", mcp_server_mod)
sys.modules.setdefault("mcp.server.models", mcp_server_models)
sys.modules.setdefault("mcp.server.stdio", mcp_server_stdio)

from cursor_mcp_server import (
    execution_results,
    handle_list_resources,
    handle_list_tools,
    handle_read_resource,
    handle_call_tool,
    trigger_talkback_speech,
)


def run_async(coro):
    """Run an async coroutine synchronously for testing."""
    loop = asyncio.new_event_loop()
    try:
        return loop.run_until_complete(coro)
    finally:
        loop.close()


class TestExecutionResultsState(unittest.TestCase):
    """Tests for the global execution_results state."""

    def setUp(self):
        execution_results["last_run_time"] = None
        execution_results["last_output"] = ""
        execution_results["error_count"] = 0
        execution_results["linter_errors"] = []
        execution_results["success"] = False

    def test_initial_state(self):
        self.assertIsNone(execution_results["last_run_time"])
        self.assertEqual(execution_results["last_output"], "")
        self.assertEqual(execution_results["error_count"], 0)
        self.assertEqual(execution_results["linter_errors"], [])
        self.assertFalse(execution_results["success"])

    def test_state_keys(self):
        expected_keys = {
            "last_run_time",
            "last_output",
            "error_count",
            "linter_errors",
            "success",
        }
        self.assertEqual(set(execution_results.keys()), expected_keys)


class TestListResources(unittest.TestCase):
    """Tests for the list_resources handler."""

    def test_returns_two_resources(self):
        resources = run_async(handle_list_resources())
        self.assertEqual(len(resources), 2)

    def test_execution_results_resource(self):
        resources = run_async(handle_list_resources())
        uris = [r.uri for r in resources]
        self.assertIn("talkback://execution-results", uris)

    def test_linter_errors_resource(self):
        resources = run_async(handle_list_resources())
        uris = [r.uri for r in resources]
        self.assertIn("talkback://linter-errors", uris)

    def test_resources_have_names(self):
        resources = run_async(handle_list_resources())
        for resource in resources:
            self.assertTrue(len(resource.name) > 0)

    def test_resources_have_descriptions(self):
        resources = run_async(handle_list_resources())
        for resource in resources:
            self.assertTrue(len(resource.description) > 0)

    def test_resources_have_json_mime_type(self):
        resources = run_async(handle_list_resources())
        for resource in resources:
            self.assertEqual(resource.mimeType, "application/json")


class TestReadResource(unittest.TestCase):
    """Tests for the read_resource handler."""

    def setUp(self):
        execution_results["last_run_time"] = None
        execution_results["last_output"] = ""
        execution_results["error_count"] = 0
        execution_results["linter_errors"] = []
        execution_results["success"] = False

    def test_read_execution_results(self):
        result = run_async(handle_read_resource("talkback://execution-results"))
        data = json.loads(result)
        self.assertIn("last_run_time", data)
        self.assertIn("error_count", data)
        self.assertIn("success", data)

    def test_read_linter_errors(self):
        result = run_async(handle_read_resource("talkback://linter-errors"))
        data = json.loads(result)
        self.assertIn("linter_errors", data)
        self.assertIn("error_count", data)

    def test_read_unknown_resource_raises(self):
        with self.assertRaises(ValueError):
            run_async(handle_read_resource("talkback://unknown"))

    def test_execution_results_reflect_state(self):
        execution_results["error_count"] = 42
        execution_results["success"] = True
        result = run_async(handle_read_resource("talkback://execution-results"))
        data = json.loads(result)
        self.assertEqual(data["error_count"], 42)
        self.assertTrue(data["success"])

    def test_linter_errors_reflect_state(self):
        execution_results["linter_errors"] = ["err1", "err2"]
        execution_results["error_count"] = 2
        result = run_async(handle_read_resource("talkback://linter-errors"))
        data = json.loads(result)
        self.assertEqual(data["linter_errors"], ["err1", "err2"])
        self.assertEqual(data["error_count"], 2)


class TestListTools(unittest.TestCase):
    """Tests for the list_tools handler."""

    def test_returns_two_tools(self):
        tools = run_async(handle_list_tools())
        self.assertEqual(len(tools), 2)

    def test_report_code_execution_tool(self):
        tools = run_async(handle_list_tools())
        names = [t.name for t in tools]
        self.assertIn("report_code_execution", names)

    def test_trigger_talkback_roast_tool(self):
        tools = run_async(handle_list_tools())
        names = [t.name for t in tools]
        self.assertIn("trigger_talkback_roast", names)

    def test_tools_have_descriptions(self):
        tools = run_async(handle_list_tools())
        for tool in tools:
            self.assertTrue(len(tool.description) > 0)

    def test_tools_have_input_schemas(self):
        tools = run_async(handle_list_tools())
        for tool in tools:
            self.assertIsNotNone(tool.inputSchema)

    def test_report_tool_required_fields(self):
        tools = run_async(handle_list_tools())
        report_tool = next(t for t in tools if t.name == "report_code_execution")
        required = report_tool.inputSchema.get("required", [])
        self.assertIn("output", required)
        self.assertIn("error_count", required)
        self.assertIn("success", required)


class TestCallToolReportCodeExecution(unittest.TestCase):
    """Tests for the report_code_execution tool handler."""

    def setUp(self):
        execution_results["last_run_time"] = None
        execution_results["last_output"] = ""
        execution_results["error_count"] = 0
        execution_results["linter_errors"] = []
        execution_results["success"] = False

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_report_with_multiple_errors_triggers_roast(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "error error", "error_count": 5, "success": False},
            )
        )
        self.assertEqual(len(result), 1)
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "roast")
        self.assertEqual(data["error_count"], 5)

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_report_with_one_error_triggers_minor_sass(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "one error", "error_count": 1, "success": False},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "minor_sass")

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_report_success_triggers_sassy_success(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "all good", "error_count": 0, "success": True},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "sassy_success")

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_report_updates_global_state(self, mock_speech):
        run_async(
            handle_call_tool(
                "report_code_execution",
                {
                    "output": "test output",
                    "error_count": 3,
                    "success": False,
                    "linter_errors": ["err1", "err2"],
                },
            )
        )
        self.assertEqual(execution_results["last_output"], "test output")
        self.assertEqual(execution_results["error_count"], 3)
        self.assertFalse(execution_results["success"])
        self.assertEqual(execution_results["linter_errors"], ["err1", "err2"])
        self.assertIsNotNone(execution_results["last_run_time"])

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_report_calls_trigger_talkback_speech(self, mock_speech):
        run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "errors!", "error_count": 2, "success": False},
            )
        )
        mock_speech.assert_called_once()
        args = mock_speech.call_args[0]
        self.assertEqual(args[1], "roast")

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_report_two_errors_is_roast_boundary(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "two errors", "error_count": 2, "success": False},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "roast")


class TestCallToolTriggerRoast(unittest.TestCase):
    """Tests for the trigger_talkback_roast tool handler."""

    def setUp(self):
        execution_results["last_run_time"] = None
        execution_results["last_output"] = ""
        execution_results["error_count"] = 0
        execution_results["linter_errors"] = []
        execution_results["success"] = False

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_trigger_without_recent_execution(self, mock_speech):
        result = run_async(
            handle_call_tool("trigger_talkback_roast", {"force": False})
        )
        self.assertIn("No recent", result[0].text)
        mock_speech.assert_not_called()

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_trigger_with_force(self, mock_speech):
        result = run_async(
            handle_call_tool("trigger_talkback_roast", {"force": True})
        )
        self.assertIn("triggered", result[0].text)
        mock_speech.assert_called_once()

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_trigger_with_recent_execution(self, mock_speech):
        execution_results["last_run_time"] = time.time()
        execution_results["error_count"] = 3
        result = run_async(
            handle_call_tool("trigger_talkback_roast", {"force": False})
        )
        self.assertIn("triggered", result[0].text)
        mock_speech.assert_called_once()

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_trigger_with_no_arguments(self, mock_speech):
        result = run_async(handle_call_tool("trigger_talkback_roast", None))
        self.assertIn("No recent", result[0].text)

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_trigger_force_with_no_arguments_dict(self, mock_speech):
        result = run_async(
            handle_call_tool("trigger_talkback_roast", {"force": True})
        )
        mock_speech.assert_called_once()


class TestCallToolUnknown(unittest.TestCase):
    """Tests for unknown tool calls."""

    def test_unknown_tool_raises(self):
        with self.assertRaises(ValueError):
            run_async(handle_call_tool("unknown_tool", {}))


class TestTriggerTalkbackSpeech(unittest.TestCase):
    """Tests for the trigger_talkback_speech helper."""

    def test_writes_message_file(self):
        with tempfile.NamedTemporaryFile(suffix=".json", delete=False) as f:
            tmppath = f.name

        with patch("cursor_mcp_server.sys") as mock_sys:
            mock_sys.stderr = MagicMock()
            with patch(
                "builtins.open",
                unittest.mock.mock_open(),
            ) as mock_open_func:
                run_async(trigger_talkback_speech("test prompt", "roast"))
                mock_open_func.assert_called_once_with(
                    "/tmp/talkback_message.json", "w"
                )

    def test_message_contains_required_fields(self):
        written_data = {}

        def fake_open(path, mode):
            class FakeFile:
                def __enter__(self):
                    return self

                def __exit__(self, *args):
                    pass

                def write(self, data):
                    pass

            return FakeFile()

        with patch("builtins.open", side_effect=fake_open):
            with patch("json.dump") as mock_dump:
                with patch("cursor_mcp_server.sys"):
                    run_async(
                        trigger_talkback_speech("test prompt", "roast")
                    )
                    call_args = mock_dump.call_args[0][0]
                    self.assertEqual(call_args["prompt"], "test prompt")
                    self.assertEqual(call_args["type"], "roast")
                    self.assertIn("timestamp", call_args)


class TestResponseTypeThresholds(unittest.TestCase):
    """Tests to verify error count thresholds map to correct response types."""

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_zero_errors_sassy_success(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "ok", "error_count": 0, "success": True},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "sassy_success")

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_one_error_minor_sass(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "err", "error_count": 1, "success": False},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "minor_sass")

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_two_errors_roast(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "errs", "error_count": 2, "success": False},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "roast")

    @patch("cursor_mcp_server.trigger_talkback_speech", new_callable=AsyncMock)
    def test_ten_errors_roast(self, mock_speech):
        result = run_async(
            handle_call_tool(
                "report_code_execution",
                {"output": "many errs", "error_count": 10, "success": False},
            )
        )
        data = json.loads(result[0].text)
        self.assertEqual(data["response_type"], "roast")


if __name__ == "__main__":
    unittest.main()
