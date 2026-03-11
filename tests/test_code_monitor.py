"""Tests for cursor_code_monitor.CodeExecutionMonitor."""

import json
import os
import tempfile
import unittest
from unittest.mock import patch

import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from cursor_code_monitor import CodeExecutionMonitor


class TestCountErrorsInOutput(unittest.TestCase):
    def setUp(self):
        self.monitor = CodeExecutionMonitor()

    def test_no_errors(self):
        self.assertEqual(self.monitor.count_errors_in_output("all good"), 0)

    def test_empty_string(self):
        self.assertEqual(self.monitor.count_errors_in_output(""), 0)

    def test_single_error(self):
        output = "file.py:10: error: something went wrong"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 1)

    def test_traceback(self):
        output = "Traceback (most recent call last):\n  File 'x.py'\nValueError: bad"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 1)

    def test_multiple_distinct_errors(self):
        output = "SyntaxError: invalid syntax\nTypeError: bad type\nImportError: no module"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 3)

    def test_compilation_failed(self):
        output = "compilation failed with 3 errors"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 1)

    def test_build_failed(self):
        output = "build failed"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 1)

    def test_case_insensitive(self):
        output = "ERROR: something\nerror: another"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreaterEqual(count, 2)

    def test_clean_output_no_false_positives(self):
        output = "Success! All 42 tests passed.\nBuild completed in 3.2s"
        self.assertEqual(self.monitor.count_errors_in_output(output), 0)

    def test_module_not_found_error(self):
        output = "ModuleNotFoundError: No module named 'foo'"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 1)

    def test_attribute_error(self):
        output = "AttributeError: 'NoneType' object has no attribute 'x'"
        self.assertGreaterEqual(self.monitor.count_errors_in_output(output), 1)


class TestSendToTalkback(unittest.TestCase):
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

    def test_roast_mode(self):
        self.monitor.send_to_talkback("lots of errors", 5, False)
        msg = self._read_message()
        self.assertEqual(msg["type"], "roast")
        self.assertEqual(msg["error_count"], 5)
        self.assertFalse(msg["success"])

    def test_minor_sass(self):
        self.monitor.send_to_talkback("one error", 1, False)
        msg = self._read_message()
        self.assertEqual(msg["type"], "minor_sass")
        self.assertEqual(msg["error_count"], 1)

    def test_sassy_success(self):
        self.monitor.send_to_talkback("all good", 0, True)
        msg = self._read_message()
        self.assertEqual(msg["type"], "sassy_success")
        self.assertEqual(msg["error_count"], 0)
        self.assertTrue(msg["success"])

    def test_message_has_required_keys(self):
        self.monitor.send_to_talkback("output", 0, True)
        msg = self._read_message()
        for key in ("prompt", "type", "timestamp", "error_count", "success"):
            self.assertIn(key, msg)

    def test_negative_error_count_clamped(self):
        self.monitor.send_to_talkback("output", -1, True)
        msg = self._read_message()
        self.assertEqual(msg["error_count"], 0)
        self.assertEqual(msg["type"], "sassy_success")

    def test_invalid_error_count_type(self):
        self.monitor.send_to_talkback("output", "not_a_number", True)
        msg = self._read_message()
        self.assertEqual(msg["error_count"], 0)

    def test_write_failure_does_not_raise(self):
        self.monitor.talkback_message_file = "/nonexistent/path/file.json"
        self.monitor.send_to_talkback("output", 1, False)

    def test_output_truncated_in_roast(self):
        long_output = "x" * 1000
        self.monitor.send_to_talkback(long_output, 3, False)
        msg = self._read_message()
        self.assertLessEqual(len(msg["prompt"]), 600)

    def test_boundary_error_count_two(self):
        self.monitor.send_to_talkback("errors", 2, False)
        msg = self._read_message()
        self.assertEqual(msg["type"], "roast")


class TestMonitorTerminalCommand(unittest.TestCase):
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
        self.assertIn(msg["type"], ("roast", "minor_sass"))
        self.assertFalse(msg["success"])

    def test_empty_command_returns_early(self):
        self.monitor.monitor_terminal_command("")

    def test_whitespace_command_returns_early(self):
        self.monitor.monitor_terminal_command("   ")

    def test_timeout_handling(self):
        self.monitor.monitor_terminal_command("sleep 10", timeout=1)
        msg = self._read_message()
        self.assertFalse(msg["success"])

    def test_updates_last_error_count(self):
        self.monitor.monitor_terminal_command("echo hello")
        self.assertEqual(self.monitor.last_error_count, 0)

    def test_nonexistent_command(self):
        self.monitor.monitor_terminal_command("nonexistent_command_xyz_123")
        msg = self._read_message()
        self.assertFalse(msg["success"])


class TestCodeExecutionMonitorInit(unittest.TestCase):
    def test_default_message_file(self):
        monitor = CodeExecutionMonitor()
        self.assertEqual(monitor.talkback_message_file, "/tmp/talkback_message.json")

    def test_custom_message_file(self):
        monitor = CodeExecutionMonitor(talkback_message_file="/tmp/custom.json")
        self.assertEqual(monitor.talkback_message_file, "/tmp/custom.json")

    def test_initial_error_count(self):
        monitor = CodeExecutionMonitor()
        self.assertEqual(monitor.last_error_count, 0)


if __name__ == "__main__":
    unittest.main()
