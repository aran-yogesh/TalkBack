#!/usr/bin/env python3
"""
Test script to verify MCP server connection

.. deprecated::
    This test uses file-based IPC which is deprecated.
    A future version will use a proper socket/HTTP connection.
"""

import json
import subprocess
import sys
import time
import warnings


def test_mcp_server():
    """Deprecated: uses file-based IPC that will be replaced."""
    warnings.warn(
        "test_mcp_server uses file-based IPC which is deprecated. "
        "A future version will use a proper socket/HTTP connection.",
        DeprecationWarning,
        stacklevel=2,
    )
    
    # Test message to send to TalkBack
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
