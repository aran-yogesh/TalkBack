"""Shared utilities for the TalkBack message delivery pipeline."""

import fcntl
import json
import os
import tempfile
import time
import uuid

DEFAULT_MESSAGE_FILE = "/tmp/talkback_message.json"

MESSAGE_FILE = os.environ.get("TALKBACK_MESSAGE_PATH", DEFAULT_MESSAGE_FILE)


def build_message(prompt: str, response_type: str, *, error_count: int = 0, success: bool = False) -> dict:
    """Build a canonical TalkBack message with all required fields."""
    return {
        "id": str(uuid.uuid4()),
        "prompt": prompt,
        "type": response_type,
        "timestamp": time.time(),
        "error_count": error_count,
        "success": success,
    }


def write_message_atomic(message: dict, target_path: str | None = None) -> None:
    """Atomically write a JSON message using write-to-temp + rename with file locking."""
    target_path = target_path or MESSAGE_FILE
    dir_name = os.path.dirname(target_path) or "/tmp"
    fd, tmp_path = tempfile.mkstemp(dir=dir_name, suffix=".tmp")
    try:
        with os.fdopen(fd, "w") as f:
            fcntl.flock(f, fcntl.LOCK_EX)
            json.dump(message, f)
            f.flush()
            os.fsync(f.fileno())
            fcntl.flock(f, fcntl.LOCK_UN)
        os.rename(tmp_path, target_path)
    except Exception:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise
