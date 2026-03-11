#!/usr/bin/env python3
"""Test script to verify MCP server connection."""

import json
import os
import time

TALKBACK_MESSAGE_FILE = "/tmp/talkback_message.json"


def test_mcp_server(message_file: str = TALKBACK_MESSAGE_FILE) -> bool:
    """Write a test message to the TalkBack message file and verify it."""
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }

    try:
        with open(message_file, "w") as f:
            json.dump(test_message, f)
    except OSError as exc:
        print(f"❌ Failed to write test message: {exc}")
        return False

    if not os.path.isfile(message_file):
        print("❌ Message file was not created")
        return False

    try:
        with open(message_file) as f:
            written = json.load(f)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"❌ Failed to read back message file: {exc}")
        return False

    required_keys = {"prompt", "type", "timestamp"}
    missing = required_keys - set(written.keys())
    if missing:
        print(f"❌ Message file missing keys: {missing}")
        return False

    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content: {json.dumps(written, indent=2)}")
    return True


if __name__ == "__main__":
    success = test_mcp_server()
    raise SystemExit(0 if success else 1)
