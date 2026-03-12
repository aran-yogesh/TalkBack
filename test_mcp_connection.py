#!/usr/bin/env python3
"""Test script to verify MCP server connection."""

import json
import os
import sys
import tempfile
import time


def test_mcp_server():
    """Send a test message through the TalkBack message queue."""
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }

    queue_dir = "/tmp/talkback_queue"
    legacy_file = "/tmp/talkback_message.json"

    try:
        os.makedirs(queue_dir, exist_ok=True)

        fd, tmp_path = tempfile.mkstemp(dir=queue_dir, suffix=".json.tmp")
        with os.fdopen(fd, "w") as f:
            json.dump(test_message, f)
            f.flush()
            os.fsync(f.fileno())
        final_path = tmp_path.replace(".json.tmp", ".json")
        os.rename(tmp_path, final_path)

        fd2, tmp_legacy = tempfile.mkstemp(
            dir=os.path.dirname(legacy_file), suffix=".tmp"
        )
        with os.fdopen(fd2, "w") as f:
            json.dump(test_message, f)
            f.flush()
            os.fsync(f.fileno())
        os.rename(tmp_legacy, legacy_file)

        print("✅ Test message sent to TalkBack!")
        print(f"📁 Queue directory: {queue_dir}")
        print(f"📁 Legacy file: {legacy_file}")
        print(f"📝 Message content: {json.dumps(test_message, indent=2)}")
        return True
    except OSError as exc:
        print(f"❌ Failed to send test message: {exc}")
        return False


if __name__ == "__main__":
    success = test_mcp_server()
    sys.exit(0 if success else 1)
