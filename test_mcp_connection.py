#!/usr/bin/env python3
"""
Test script to verify MCP server connection

DEPRECATED: This test relies on file-based IPC via /tmp/talkback_message.json
which is a deprecated communication pattern. It will be removed in a future
release along with cursor_mcp_server.py.
"""

import json
import time
import warnings

warnings.warn(
    "test_mcp_connection.py is deprecated along with the file-based IPC "
    "pattern it tests. This file will be removed in a future release.",
    DeprecationWarning,
    stacklevel=2,
)


def test_mcp_server():
    """Test the MCP server by sending a test message (deprecated)."""
    warnings.warn(
        "File-based IPC via /tmp/talkback_message.json is deprecated. "
        "The built-in Swift MCP monitoring is the recommended replacement.",
        DeprecationWarning,
        stacklevel=2,
    )

    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time(),
    }

    message_file = "/tmp/talkback_message.json"
    with open(message_file, "w") as f:
        json.dump(test_message, f)

    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content: {json.dumps(test_message, indent=2)}")

    return True


if __name__ == "__main__":
    test_mcp_server()
