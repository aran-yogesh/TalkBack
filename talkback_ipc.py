"""Reliable file-based IPC for the TalkBack message pipeline.

Provides atomic writes with file locking so multiple Python writers
(cursor_mcp_server, cursor_code_monitor, test scripts) cannot corrupt
or silently overwrite each other's messages.
"""

import fcntl
import json
import os
import sys
import tempfile
import time
import uuid

DEFAULT_MESSAGE_FILE = os.environ.get(
    "TALKBACK_MESSAGE_FILE", "/tmp/talkback_message.json"
)

_MAX_RETRIES = 3
_RETRY_DELAY = 0.05  # 50 ms


def _atomic_write(filepath: str, payload: dict) -> None:
    """Write *payload* as JSON to *filepath* atomically via temp-file + rename."""
    dir_name = os.path.dirname(filepath) or "/tmp"
    fd, tmp_path = tempfile.mkstemp(dir=dir_name, suffix=".talkback.tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            json.dump(payload, f)
            f.flush()
            os.fsync(f.fileno())
        os.replace(tmp_path, filepath)
    except BaseException:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise


def send_message(
    prompt: str,
    response_type: str,
    *,
    message_file: str = DEFAULT_MESSAGE_FILE,
    extra_fields: dict | None = None,
) -> bool:
    """Write a TalkBack message reliably.

    Returns True on success, False after exhausting retries.
    """
    payload: dict = {
        "prompt": prompt,
        "type": response_type,
        "timestamp": time.time(),
        "msg_id": uuid.uuid4().hex,
    }
    if extra_fields:
        payload.update(extra_fields)

    lock_path = message_file + ".lock"

    for attempt in range(1, _MAX_RETRIES + 1):
        try:
            lock_fd = os.open(lock_path, os.O_CREAT | os.O_RDWR)
            try:
                fcntl.flock(lock_fd, fcntl.LOCK_EX)
                _atomic_write(message_file, payload)
            finally:
                fcntl.flock(lock_fd, fcntl.LOCK_UN)
                os.close(lock_fd)
            return True
        except OSError as exc:
            print(
                f"⚠️  TalkBack IPC write attempt {attempt}/{_MAX_RETRIES} "
                f"failed: {exc}",
                file=sys.stderr,
            )
            if attempt < _MAX_RETRIES:
                time.sleep(_RETRY_DELAY)

    print("❌ TalkBack IPC: message delivery failed after retries", file=sys.stderr)
    return False
