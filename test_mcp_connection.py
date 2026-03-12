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
    """Test the MCP server by sending a test message"""
    
    # Test message to send to TalkBack
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    # Atomic write to the file that TalkBack monitors
    message_file = "/tmp/talkback_message.json"
    try:
        tmp_fd = tempfile.NamedTemporaryFile(
            mode="w", dir="/tmp", suffix=".json", delete=False
        )
        try:
            json.dump(test_message, tmp_fd)
            tmp_fd.flush()
            os.fsync(tmp_fd.fileno())
            tmp_fd.close()
            os.replace(tmp_fd.name, message_file)
        except BaseException:
            tmp_fd.close()
            if os.path.exists(tmp_fd.name):
                os.unlink(tmp_fd.name)
            raise
        
        print("✅ Test message sent to TalkBack!")
        print(f"📁 Message file: {message_file}")
        print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
    except Exception as e:
        print(f"❌ Error sending test message: {e}")
        return False
    
    return True

if __name__ == "__main__":
    test_mcp_server()
