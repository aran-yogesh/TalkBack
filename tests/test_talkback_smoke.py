import json
import math
import os
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import test_mcp_connection


MESSAGE_FILE = "/tmp/talkback_message.json"
EXPECTED_PROMPT = "Test message from MCP server! Your code monitoring is working! 🎉"


def test_test_mcp_server_writes_message():
    if os.path.exists(MESSAGE_FILE):
        os.remove(MESSAGE_FILE)

    result = test_mcp_connection.test_mcp_server()

    assert result is True
    assert os.path.exists(MESSAGE_FILE)

    with open(MESSAGE_FILE, "r") as handle:
        payload = json.load(handle)

    assert payload["prompt"] == EXPECTED_PROMPT
    assert payload["type"] == "test"
    assert isinstance(payload["timestamp"], (int, float))
    assert math.isfinite(payload["timestamp"])

    os.remove(MESSAGE_FILE)
