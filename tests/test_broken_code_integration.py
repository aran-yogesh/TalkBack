"""Integration tests: run broken_code.py through CodeExecutionMonitor."""

import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from cursor_code_monitor import CodeExecutionMonitor


class TestBrokenCodeIntegration(unittest.TestCase):
    def setUp(self):
        self.tmpfile = tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        )
        self.tmpfile.close()
        self.monitor = CodeExecutionMonitor(
            talkback_message_file=self.tmpfile.name
        )
        self.broken_code_path = os.path.join(
            os.path.dirname(__file__), "..", "broken_code.py"
        )

    def tearDown(self):
        if os.path.exists(self.tmpfile.name):
            os.unlink(self.tmpfile.name)

    def _read_message(self):
        with open(self.tmpfile.name) as f:
            return json.load(f)

    def test_broken_code_produces_errors(self):
        self.monitor.monitor_terminal_command(f"python3 {self.broken_code_path}")
        msg = self._read_message()
        self.assertGreater(msg["error_count"], 0)
        self.assertFalse(msg["success"])

    def test_broken_code_triggers_roast_or_sass(self):
        self.monitor.monitor_terminal_command(f"python3 {self.broken_code_path}")
        msg = self._read_message()
        self.assertIn(msg["type"], ("roast", "minor_sass"))

    def test_broken_code_has_traceback_in_prompt(self):
        self.monitor.monitor_terminal_command(f"python3 {self.broken_code_path}")
        msg = self._read_message()
        self.assertIn("error", msg["prompt"].lower())

    def test_successful_code_produces_success(self):
        self.monitor.monitor_terminal_command("python3 -c 'print(42)'")
        msg = self._read_message()
        self.assertEqual(msg["type"], "sassy_success")
        self.assertTrue(msg["success"])
        self.assertEqual(msg["error_count"], 0)


if __name__ == "__main__":
    unittest.main()
