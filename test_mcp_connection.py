#!/usr/bin/env python3
"""Smoke test for the TalkBack MCP server connection.

Writes a test JSON payload to the shared message file
(``/tmp/talkback_message.json``) and prints confirmation.
Run this script to verify that the file-based IPC path between the MCP
server and the TalkBack avatar is functional.
"""

import json
import subprocess
import sys
import time


def test_mcp_server():
    """Write a test payload to the TalkBack message file and return True on success."""
    
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
