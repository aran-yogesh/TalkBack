#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import time

from talkback_logging import setup_logger


logger = setup_logger("talkback.mcp_connection_test")


def test_mcp_server():
    """Test the MCP server by sending a test message"""
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }

    message_file = "/tmp/talkback_message.json"
    try:
        with open(message_file, "w") as f:
            json.dump(test_message, f)
    except Exception:
        logger.exception("Failed to write test message")
        return False

    logger.info("Test message sent to TalkBack")
    logger.debug("Message file: %s", message_file)
    logger.debug("Message content: %s", json.dumps(test_message, indent=2))

    return True

if __name__ == "__main__":
    test_mcp_server()
