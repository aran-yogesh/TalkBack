#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import logging
import time


def setup_logging() -> logging.Logger:
    """Set up logging for the MCP connection test."""
    logger = logging.getLogger("talkback_mcp_test")
    if logger.handlers:
        return logger
    logger.setLevel(logging.INFO)
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(name)s: %(message)s")
    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(formatter)
    file_handler = logging.FileHandler("/tmp/talkback_mcp_test.log")
    file_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)
    logger.addHandler(file_handler)
    logger.propagate = False
    return logger


logger = setup_logging()


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
        with open(message_file, "w") as f:
            json.dump(test_message, f)
    except OSError as exc:
        logger.exception("Failed to write test message: %s", exc)
        return False

    logger.info("Test message sent to TalkBack")
    logger.info("Message file: %s", message_file)
    logger.info("Message content: %s", json.dumps(test_message, indent=2))

    return True

if __name__ == "__main__":
    test_mcp_server()
