#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import subprocess
import sys
import time

from talkback_utils import MESSAGE_FILE, build_message, write_message_atomic


def test_mcp_server():
    """Test the MCP server by sending a test message."""
    test_message = build_message(
        "Test message from MCP server! Your code monitoring is working! 🎉",
        "test",
    )

    try:
        write_message_atomic(test_message)
    except Exception as e:
        print(f"❌ Failed to send test message: {e}")
        return False

    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {MESSAGE_FILE}")
    print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
    return True

if __name__ == "__main__":
    test_mcp_server()
