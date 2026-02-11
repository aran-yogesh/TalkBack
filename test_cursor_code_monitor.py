#!/usr/bin/env python3
"""Tests for cursor_code_monitor.py"""

import json
import os
import sys
import tempfile
import types as builtin_types
import unittest
from unittest.mock import patch, MagicMock

watchdog_events = builtin_types.ModuleType("watchdog.events")
watchdog_observers = builtin_types.ModuleType("watchdog.observers")
watchdog_events.FileSystemEventHandler = type(
    "FileSystemEventHandler", (), {}
)
watchdog_observers.Observer = type("Observer", (), {})
sys.modules.setdefault("watchdog", builtin_types.ModuleType("watchdog"))
sys.modules.setdefault("watchdog.events", watchdog_events)
sys.modules.setdefault("watchdog.observers", watchdog_observers)

from cursor_code_monitor import CodeExecutionMonitor


class TestCodeExecutionMonitorInit(unittest.TestCase):
    """Tests for CodeExecutionMonitor initialisation."""

    def test_default_message_file(self):
        monitor = CodeExecutionMonitor()
        self.assertEqual(monitor.talkback_message_file, "/tmp/talkback_message.json")

    def test_custom_message_file(self):
        monitor = CodeExecutionMonitor(talkback_message_file="/tmp/custom.json")
        self.assertEqual(monitor.talkback_message_file, "/tmp/custom.json")

    def test_initial_state(self):
        monitor = CodeExecutionMonitor()
        self.assertEqual(monitor.last_error_count, 0)
        self.assertTrue(monitor.monitoring)


class TestCountErrorsInOutput(unittest.TestCase):
    """Tests for error counting in terminal output."""

    def setUp(self):
        self.monitor = CodeExecutionMonitor()

    def test_no_errors(self):
        output = "All tests passed!\nDone."
        self.assertEqual(self.monitor.count_errors_in_output(output), 0)

    def test_single_error(self):
        output = "error: something went wrong"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 1)

    def test_multiple_errors(self):
        output = "Error: first\nError: second\nError: third"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 3)

    def test_traceback(self):
        output = "Traceback (most recent call last):\n  File 'test.py', line 1\nNameError: name 'x' is not defined"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_syntax_error(self):
        output = "SyntaxError: unexpected EOF while parsing"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_type_error(self):
        output = "TypeError: unsupported operand type(s)"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_value_error(self):
        output = "ValueError: invalid literal for int()"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_attribute_error(self):
        output = "AttributeError: 'NoneType' object has no attribute 'foo'"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_import_error(self):
        output = "ImportError: No module named 'nonexistent'"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_module_not_found_error(self):
        output = "ModuleNotFoundError: No module named 'missing_lib'"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_compilation_failed(self):
        output = "compilation failed with 2 errors"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_build_failed(self):
        output = "build failed"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_test_failed(self):
        output = "test failed: expected 3 but got 4"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_exception_keyword(self):
        output = "Exception: something bad happened"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_empty_output(self):
        self.assertEqual(self.monitor.count_errors_in_output(""), 0)

    def test_mixed_errors_and_success(self):
        output = "Running tests...\nError: assertion failed\nOK - 5 passed"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_case_insensitive_error(self):
        output = "ERROR: uppercase error detected"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)


class TestSendToTalkback(unittest.TestCase):
    """Tests for TalkBack message generation and file writing."""

    def setUp(self):
        self.tmpfile = tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        )
        self.tmpfile.close()
        self.monitor = CodeExecutionMonitor(
            talkback_message_file=self.tmpfile.name
        )

    def tearDown(self):
        if os.path.exists(self.tmpfile.name):
            os.unlink(self.tmpfile.name)

    def _read_message(self):
        with open(self.tmpfile.name) as f:
            return json.load(f)

    def test_roast_on_multiple_errors(self):
        self.monitor.send_to_talkback("error error", 3, False)
        msg = self._read_message()
        self.assertEqual(msg["type"], "roast")
        self.assertEqual(msg["error_count"], 3)
        self.assertFalse(msg["success"])
        self.assertIn("ROAST", msg["prompt"])

    def test_minor_sass_on_single_error(self):
        self.monitor.send_to_talkback("one error", 1, False)
        msg = self._read_message()
        self.assertEqual(msg["type"], "minor_sass")
        self.assertEqual(msg["error_count"], 1)
        self.assertFalse(msg["success"])

    def test_sassy_success_on_zero_errors(self):
        self.monitor.send_to_talkback("all good", 0, True)
        msg = self._read_message()
        self.assertEqual(msg["type"], "sassy_success")
        self.assertEqual(msg["error_count"], 0)
        self.assertTrue(msg["success"])

    def test_message_contains_timestamp(self):
        self.monitor.send_to_talkback("output", 0, True)
        msg = self._read_message()
        self.assertIn("timestamp", msg)
        self.assertIsInstance(msg["timestamp"], float)

    def test_prompt_truncation_for_roast(self):
        long_output = "x" * 1000
        self.monitor.send_to_talkback(long_output, 5, False)
        msg = self._read_message()
        self.assertLessEqual(len(msg["prompt"]), 600)

    def test_prompt_truncation_for_minor_sass(self):
        long_output = "y" * 1000
        self.monitor.send_to_talkback(long_output, 1, False)
        msg = self._read_message()
        self.assertLessEqual(len(msg["prompt"]), 400)

    def test_two_errors_triggers_roast(self):
        self.monitor.send_to_talkback("errors", 2, False)
        msg = self._read_message()
        self.assertEqual(msg["type"], "roast")

    def test_write_error_handled_gracefully(self):
        self.monitor.talkback_message_file = "/nonexistent/path/file.json"
        self.monitor.send_to_talkback("output", 0, True)


class TestMonitorTerminalCommand(unittest.TestCase):
    """Tests for running and monitoring shell commands."""

    def setUp(self):
        self.tmpfile = tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        )
        self.tmpfile.close()
        self.monitor = CodeExecutionMonitor(
            talkback_message_file=self.tmpfile.name
        )

    def tearDown(self):
        if os.path.exists(self.tmpfile.name):
            os.unlink(self.tmpfile.name)

    def _read_message(self):
        with open(self.tmpfile.name) as f:
            return json.load(f)

    def test_successful_command(self):
        self.monitor.monitor_terminal_command("echo hello")
        msg = self._read_message()
        self.assertEqual(msg["type"], "sassy_success")
        self.assertTrue(msg["success"])

    def test_failing_command(self):
        self.monitor.monitor_terminal_command("python3 -c 'raise ValueError(\"boom\")'")
        msg = self._read_message()
        self.assertGreater(msg["error_count"], 0)
        self.assertFalse(msg["success"])

    def test_syntax_error_command(self):
        self.monitor.monitor_terminal_command("python3 -c 'def'")
        msg = self._read_message()
        self.assertGreater(msg["error_count"], 0)

    def test_timeout_command(self):
        with patch("cursor_code_monitor.CodeExecutionMonitor.send_to_talkback") as mock_send:
            self.monitor.monitor_terminal_command("sleep 60")
            mock_send.assert_called_once()
            args = mock_send.call_args[0]
            self.assertIn("timed out", args[0])
            self.assertEqual(args[1], 1)
            self.assertFalse(args[2])

    @patch("subprocess.run", side_effect=OSError("command not found"))
    def test_os_error_command(self, mock_run):
        with patch("cursor_code_monitor.CodeExecutionMonitor.send_to_talkback") as mock_send:
            self.monitor.monitor_terminal_command("nonexistent_binary_xyz")
            mock_send.assert_called_once()
            args = mock_send.call_args[0]
            self.assertEqual(args[1], 1)
            self.assertFalse(args[2])


class TestEdgeCases(unittest.TestCase):
    """Edge case and integration-style tests."""

    def test_count_errors_with_unicode(self):
        monitor = CodeExecutionMonitor()
        output = "Error: file 'café.py' not found"
        count = monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_count_errors_with_multiline_traceback(self):
        monitor = CodeExecutionMonitor()
        output = (
            "Traceback (most recent call last):\n"
            "  File \"test.py\", line 10, in <module>\n"
            "    result = 1 / 0\n"
            "ZeroDivisionError: division by zero\n"
        )
        count = monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_message_file_created_on_send(self):
        tmpdir = tempfile.mkdtemp()
        filepath = os.path.join(tmpdir, "new_message.json")
        monitor = CodeExecutionMonitor(talkback_message_file=filepath)
        monitor.send_to_talkback("output", 0, True)
        self.assertTrue(os.path.exists(filepath))
        os.unlink(filepath)
        os.rmdir(tmpdir)


if __name__ == "__main__":
    unittest.main()
