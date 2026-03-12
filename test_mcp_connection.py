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


def test_mcp_server():
    """Test the MCP server by sending a test message via atomic write."""
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    message_file = "/tmp/talkback_message.json"
    dir_name = os.path.dirname(message_file) or "/tmp"
    fd, tmp_path = tempfile.mkstemp(dir=dir_name, suffix=".tmp")
    try:
        with os.fdopen(fd, "w") as f:
            json.dump(test_message, f)
    except BaseException:
        os.unlink(tmp_path)
        raise
    os.replace(tmp_path, message_file)
    
    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
    
    return True

if __name__ == "__main__":
    test_mcp_server()
