import logging
from logging.handlers import RotatingFileHandler
import os
from pathlib import Path


def setup_logger(name: str) -> logging.Logger:
    """Return a configured logger with console and file handlers."""
    logger = logging.getLogger(name)
    if logger.handlers:
        return logger

    logger.setLevel(logging.DEBUG)
    log_dir = Path(os.getenv("TALKBACK_LOG_DIR", "/tmp"))
    log_dir.mkdir(parents=True, exist_ok=True)

    formatter = logging.Formatter("%(asctime)s %(levelname)s %(name)s: %(message)s")

    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(formatter)

    file_handler = RotatingFileHandler(log_dir / "talkback.log", maxBytes=1_000_000, backupCount=3)
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(formatter)

    error_handler = RotatingFileHandler(log_dir / "talkback_error.log", maxBytes=500_000, backupCount=5)
    error_handler.setLevel(logging.ERROR)
    error_handler.setFormatter(formatter)

    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    logger.addHandler(error_handler)
    logger.propagate = False

    return logger
