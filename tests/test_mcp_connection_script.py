"""Tests for test_mcp_connection.py script."""

import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from test_mcp_connection import test_mcp_server as run_mcp_server_test


class TestMCPConnectionScript(unittest.TestCase):
    def setUp(self):
        self.tmpfile = tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        )
        self.tmpfile.close()

    def tearDown(self):
        if os.path.exists(self.tmpfile.name):
            os.unlink(self.tmpfile.name)

    def test_returns_true_on_success(self):
        result = run_mcp_server_test(message_file=self.tmpfile.name)
        self.assertTrue(result)

    def test_writes_valid_json(self):
        run_mcp_server_test(message_file=self.tmpfile.name)
        with open(self.tmpfile.name) as f:
            msg = json.load(f)
        self.assertIn("prompt", msg)
        self.assertIn("type", msg)
        self.assertIn("timestamp", msg)

    def test_message_type_is_test(self):
        run_mcp_server_test(message_file=self.tmpfile.name)
        with open(self.tmpfile.name) as f:
            msg = json.load(f)
        self.assertEqual(msg["type"], "test")

    def test_returns_false_on_write_failure(self):
        result = run_mcp_server_test(message_file="/nonexistent/dir/file.json")
        self.assertFalse(result)

    def test_timestamp_is_numeric(self):
        run_mcp_server_test(message_file=self.tmpfile.name)
        with open(self.tmpfile.name) as f:
            msg = json.load(f)
        self.assertIsInstance(msg["timestamp"], float)


class TestMCPConnectionEdgeCases(unittest.TestCase):
    def test_overwrite_existing_file(self):
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".json", delete=False
        ) as f:
            f.write('{"old": "data"}')
            path = f.name
        try:
            run_mcp_server_test(message_file=path)
            with open(path) as f:
                msg = json.load(f)
            self.assertNotIn("old", msg)
            self.assertIn("prompt", msg)
        finally:
            os.unlink(path)


if __name__ == "__main__":
    unittest.main()
