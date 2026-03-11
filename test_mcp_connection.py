#!/usr/bin/env python3
"""Test script to verify MCP server connection."""

import json
import sys

from talkback_ipc import DEFAULT_MESSAGE_FILE, send_message


def test_mcp_server():
    """Send a test message through the reliable IPC pipeline."""
    prompt = "Test message from MCP server! Your code monitoring is working! 🎉"
    ok = send_message(prompt, "test")

    if ok:
        print("✅ Test message sent to TalkBack!")
        print(f"📁 Message file: {DEFAULT_MESSAGE_FILE}")
    else:
        print("❌ Test message delivery failed!", file=sys.stderr)
        return False
    return True


if __name__ == "__main__":
    test_mcp_server()
