#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import subprocess
import sys
import time

from talkback_ipc import atomic_write_message


def test_mcp_server():
    """Test the MCP server by sending a test message"""
    
    # Test message to send to TalkBack
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    message_file = "/tmp/talkback_message.json"
    try:
        atomic_write_message(test_message, message_file)
        print("✅ Test message sent to TalkBack!")
        print(f"📁 Message file: {message_file}")
        print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
        return True
    except OSError as exc:
        print(f"❌ Failed to send test message: {exc}")
        return False

if __name__ == "__main__":
    test_mcp_server()
