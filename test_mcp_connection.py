#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import subprocess
import sys
import time

from talkback_ipc import (
    atomic_write_message,
    atomic_write_legacy,
    TALKBACK_MESSAGE_DIR,
    TALKBACK_LEGACY_FILE,
)


def test_mcp_server():
    """Test the MCP server by sending a test message"""
    
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    result = atomic_write_message(test_message)
    if result:
        atomic_write_legacy(test_message)
        print("✅ Test message sent to TalkBack!")
        print(f"📁 Queue file: {result}")
        print(f"📁 Legacy file: {TALKBACK_LEGACY_FILE}")
        print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
    else:
        print("❌ Failed to send test message!")
        return False
    
    return True

if __name__ == "__main__":
    test_mcp_server()
