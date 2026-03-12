"""Shared helpers for reliable TalkBack message delivery over the file-based IPC channel."""

import fcntl
import json
import os
import tempfile
import time

DEFAULT_MESSAGE_FILE = "/tmp/talkback_message.json"


def atomic_write_message(message: dict, path: str = DEFAULT_MESSAGE_FILE) -> None:
    """Write *message* to *path* atomically using write-to-temp + rename.

    Also grabs an advisory lock so concurrent writers don't clobber each other.
    """
    dir_name = os.path.dirname(path) or "/tmp"
    fd, tmp_path = tempfile.mkstemp(dir=dir_name, suffix=".tmp")
    try:
        with os.fdopen(fd, "w") as tmp_f:
            fcntl.flock(tmp_f, fcntl.LOCK_EX)
            json.dump(message, tmp_f)
            tmp_f.flush()
            os.fsync(tmp_f.fileno())
        os.replace(tmp_path, path)
    except BaseException:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise
