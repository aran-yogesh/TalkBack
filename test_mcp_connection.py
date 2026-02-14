#!/usr/bin/env python3
"""
Test script to verify MCP server connection.

.. deprecated::
    The file-based IPC mechanism used by this test script is deprecated.
    Future versions will use HTTP or WebSocket transport.
"""

import json
import subprocess
import sys
import time
import warnings


def test_mcp_server():
    """Test the MCP server by sending a test message."""
    warnings.warn(
        "test_mcp_connection.py relies on file-based IPC via /tmp/talkback_message.json, "
        "which is deprecated. Future versions will use HTTP or WebSocket transport.",
        DeprecationWarning,
        stacklevel=2,
    )
    
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    # Write to the file that TalkBack monitors
    message_file = "/tmp/talkback_message.json"
    with open(message_file, "w") as f:
        json.dump(test_message, f)
    
    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
    
    return True

if __name__ == "__main__":
    test_mcp_server()
