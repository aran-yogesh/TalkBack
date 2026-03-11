"""Tests for cursor_mcp_server module."""

import asyncio
import json
import os
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from cursor_mcp_server import (
    TALKBACK_MESSAGE_FILE,
    _build_roast_prompt,
    execution_results,
    trigger_talkback_speech,
)


def _run(coro):
    loop = asyncio.new_event_loop()
    try:
        return loop.run_until_complete(coro)
    finally:
        loop.close()


class TestBuildRoastPrompt(unittest.TestCase):
    def test_roast_for_many_errors(self):
        prompt, rtype = _build_roast_prompt(5, "some output")
        self.assertEqual(rtype, "roast")
        self.assertIn("5 errors", prompt)

    def test_roast_for_two_errors(self):
        prompt, rtype = _build_roast_prompt(2, "output")
        self.assertEqual(rtype, "roast")

    def test_minor_sass_for_one_error(self):
        prompt, rtype = _build_roast_prompt(1, "one error output")
        self.assertEqual(rtype, "minor_sass")
        self.assertIn("1 error", prompt)

    def test_sassy_success_for_zero_errors(self):
        prompt, rtype = _build_roast_prompt(0, "clean output")
        self.assertEqual(rtype, "sassy_success")

    def test_sassy_success_for_negative(self):
        prompt, rtype = _build_roast_prompt(-1, "output")
        self.assertEqual(rtype, "sassy_success")

    def test_output_truncated(self):
        long_output = "x" * 1000
        prompt, _ = _build_roast_prompt(3, long_output)
        self.assertLessEqual(len(prompt), 600)

    def test_empty_output(self):
        prompt, rtype = _build_roast_prompt(2, "")
        self.assertEqual(rtype, "roast")
        self.assertIsInstance(prompt, str)


class TestTriggerTalkbackSpeech(unittest.TestCase):
    def setUp(self):
        self.tmpfile = tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        )
        self.tmpfile.close()

    def tearDown(self):
        if os.path.exists(self.tmpfile.name):
            os.unlink(self.tmpfile.name)

    def test_writes_valid_json(self):
        with patch("cursor_mcp_server.TALKBACK_MESSAGE_FILE", self.tmpfile.name):
            _run(trigger_talkback_speech("test prompt", "roast"))
        with open(self.tmpfile.name) as f:
            msg = json.load(f)
        self.assertEqual(msg["prompt"], "test prompt")
        self.assertEqual(msg["type"], "roast")
        self.assertIn("timestamp", msg)

    def test_handles_write_failure(self):
        with patch("cursor_mcp_server.TALKBACK_MESSAGE_FILE", "/nonexistent/path.json"):
            _run(trigger_talkback_speech("test", "roast"))

    def test_message_structure(self):
        with patch("cursor_mcp_server.TALKBACK_MESSAGE_FILE", self.tmpfile.name):
            _run(trigger_talkback_speech("hello", "minor_sass"))
        with open(self.tmpfile.name) as f:
            msg = json.load(f)
        self.assertSetEqual(set(msg.keys()), {"prompt", "type", "timestamp"})


class TestExecutionResultsState(unittest.TestCase):
    def test_initial_state(self):
        self.assertIsNone(execution_results["last_run_time"])
        self.assertEqual(execution_results["last_output"], "")
        self.assertEqual(execution_results["error_count"], 0)
        self.assertEqual(execution_results["linter_errors"], [])
        self.assertFalse(execution_results["success"])

    def test_state_keys(self):
        expected_keys = {"last_run_time", "last_output", "error_count", "linter_errors", "success"}
        self.assertEqual(set(execution_results.keys()), expected_keys)


class TestConstants(unittest.TestCase):
    def test_talkback_message_file_path(self):
        self.assertEqual(TALKBACK_MESSAGE_FILE, "/tmp/talkback_message.json")


if __name__ == "__main__":
    unittest.main()
