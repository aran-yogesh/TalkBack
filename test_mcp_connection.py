#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import os
import subprocess
import sys
import tempfile
import time


def atomic_write_message(message_file: str, payload: dict):
    """Write JSON payload to message_file atomically via temp-file + rename."""
    dir_name = os.path.dirname(message_file) or "/tmp"
    fd, tmp_path = tempfile.mkstemp(dir=dir_name, suffix=".tmp")
    try:
        with os.fdopen(fd, "w") as f:
            json.dump(payload, f)
            f.flush()
            os.fsync(f.fileno())
        os.replace(tmp_path, message_file)
    except BaseException:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise


def test_mcp_server():
    """Test the MCP server by sending a test message"""
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }

    message_file = "/tmp/talkback_message.json"
    atomic_write_message(message_file, test_message)

    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content: {json.dumps(test_message, indent=2)}")

    return True

if __name__ == "__main__":
    test_mcp_server()
