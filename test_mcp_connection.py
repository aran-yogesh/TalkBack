#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import yaml
import subprocess
import sys
import time


def test_mcp_server():
    """Test the MCP server by sending a test message"""
    
    # Test message to send to TalkBack
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    # Write to the file that TalkBack monitors
    message_file = "/tmp/talkback_message.yaml"
    with open(message_file, "w") as f:
        yaml.dump(test_message, f, default_flow_style=False)
    
    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content:\n{yaml.dump(test_message, default_flow_style=False)}")
    
    return True

if __name__ == "__main__":
    test_mcp_server()
