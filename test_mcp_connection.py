#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import os
import sys
import tempfile
import time


def test_mcp_server():
    """Test the MCP server by sending a test message."""
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    message_file = "/tmp/talkback_message.json"
    try:
        dir_name = os.path.dirname(message_file)
        fd, tmp_path = tempfile.mkstemp(suffix=".tmp", dir=dir_name)
        try:
            with os.fdopen(fd, "w") as f:
                json.dump(test_message, f)
                f.flush()
                os.fsync(f.fileno())
            os.replace(tmp_path, message_file)
        except Exception:
            try:
                os.unlink(tmp_path)
            except OSError:
                pass
            raise
        print("✅ Test message sent to TalkBack!")
        print(f"📁 Message file: {message_file}")
        print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
        return True
    except Exception as e:
        print(f"❌ Failed to send test message: {e}")
        return False

if __name__ == "__main__":
    success = test_mcp_server()
    sys.exit(0 if success else 1)
