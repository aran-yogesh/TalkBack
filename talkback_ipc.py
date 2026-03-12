#!/usr/bin/env python3
"""Shared helpers for reliable TalkBack message delivery."""

import json
import os
import tempfile
import time

TALKBACK_MESSAGE_DIR = "/tmp/talkback_messages"
TALKBACK_LEGACY_FILE = "/tmp/talkback_message.json"


def ensure_message_dir():
    """Create the message queue directory if it doesn't exist."""
    os.makedirs(TALKBACK_MESSAGE_DIR, exist_ok=True)


def atomic_write_message(message: dict, directory: str = TALKBACK_MESSAGE_DIR):
    """Write a message as a uniquely-named JSON file using atomic rename.

    Returns the path of the written file, or None on failure.
    """
    ensure_message_dir()
    if "timestamp" not in message:
        message["timestamp"] = time.time()

    try:
        fd, tmp_path = tempfile.mkstemp(
            suffix=".tmp", prefix="msg_", dir=directory
        )
        with os.fdopen(fd, "w") as f:
            json.dump(message, f)

        final_path = tmp_path.replace(".tmp", ".json")
        os.rename(tmp_path, final_path)
        return final_path
    except Exception as e:
        print(f"❌ atomic_write_message failed: {e}")
        if os.path.exists(tmp_path):
            try:
                os.unlink(tmp_path)
            except OSError:
                pass
        return None


def atomic_write_legacy(message: dict, path: str = TALKBACK_LEGACY_FILE):
    """Write to the legacy single-file path using atomic rename."""
    if "timestamp" not in message:
        message["timestamp"] = time.time()

    tmp_path = path + ".tmp"
    try:
        with open(tmp_path, "w") as f:
            json.dump(message, f)
        os.replace(tmp_path, path)
        return path
    except Exception as e:
        print(f"❌ atomic_write_legacy failed: {e}")
        if os.path.exists(tmp_path):
            try:
                os.unlink(tmp_path)
            except OSError:
                pass
        return None
