#!/usr/bin/env python3
"""
Cursor Code Monitor - Watches for code execution and triggers TalkBack roasts
This script monitors terminal output and linter errors, then sends to TalkBack
"""

import json
import re
import subprocess
import sys
import time

from watchdog.events import FileSystemEventHandler

from talkback_logging import setup_logger


logger = setup_logger("talkback.code_monitor")


class CodeExecutionMonitor(FileSystemEventHandler):
    def __init__(self, talkback_message_file="/tmp/talkback_message.json"):
        self.talkback_message_file = talkback_message_file
        self.last_error_count = 0
        self.monitoring = True
        
    def count_errors_in_output(self, output: str) -> int:
        """Count errors in terminal output"""
        error_patterns = [
            r'error:',
            r'Error:',
            r'ERROR:',
            r'compilation failed',
            r'build failed',
            r'test failed',
            r'exception',
            r'Exception',
            r'Traceback',
            r'SyntaxError',
            r'TypeError',
            r'ValueError',
            r'AttributeError',
            r'ImportError',
            r'ModuleNotFoundError',
        ]
        
        error_count = 0
        for pattern in error_patterns:
            error_count += len(re.findall(pattern, output, re.IGNORECASE))
        
        return error_count
    
    def send_to_talkback(self, output: str, error_count: int, success: bool):
        """Send code execution results to TalkBack"""
        
        # Determine response type
        if error_count >= 2:
            response_type = "roast"
            prompt = f"ROAST ME! My code failed with {error_count} errors! Here's what happened: {output[:500]}"
        elif error_count == 1:
            response_type = "minor_sass"
            prompt = f"I got 1 error in my code. Give me a little sass: {output[:300]}"
        else:
            response_type = "sassy_success"
            prompt = "My code ran successfully! Tell me 'okay you made it this time' but with major attitude!"
        
        # Create message for TalkBack
        message = {
            "prompt": prompt,
            "type": response_type,
            "timestamp": time.time(),
            "error_count": error_count,
            "success": success
        }
        
        # Write to file that TalkBack monitors
        try:
            with open(self.talkback_message_file, "w") as f:
                json.dump(message, f, indent=2)

            logger.info("Sent to TalkBack: %s (errors: %s)", response_type, error_count)
        except Exception:
            logger.exception("Error sending to TalkBack")
    
    def monitor_terminal_command(self, command: str):
        """Run a command and monitor its output"""
        logger.info("Monitoring command: %s", command)

        try:
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                timeout=30
            )

            output = result.stdout + result.stderr
            error_count = self.count_errors_in_output(output)
            success = result.returncode == 0 and error_count == 0

            logger.info("Command finished: %s errors, success=%s", error_count, success)
            logger.debug("Output preview: %s", output[:200])

            self.send_to_talkback(output, error_count, success)

        except subprocess.TimeoutExpired:
            logger.error("Command timed out")
            self.send_to_talkback("Command timed out!", 1, False)
        except Exception:
            logger.exception("Error running command")
            self.send_to_talkback("Command failed with unexpected error", 1, False)

def main():
    logger.info("TalkBack Cursor Monitor Started")
    logger.info("Monitoring code execution and triggering roasts on errors")

    monitor = CodeExecutionMonitor()

    logger.info("Usage examples:")
    logger.info("1. Run Python: python cursor_code_monitor.py run 'python your_script.py'")
    logger.info("2. Run Swift: python cursor_code_monitor.py run 'swift your_file.swift'")
    logger.info("3. Run tests: python cursor_code_monitor.py run 'npm test'")

    if len(sys.argv) > 2 and sys.argv[1] == "run":
        command = " ".join(sys.argv[2:])
        monitor.monitor_terminal_command(command)
    else:
        logger.info("Tip: Run this script with 'run' followed by your command")
        logger.info("Example: python cursor_code_monitor.py run 'python test.py'")
        logger.info("TalkBack is watching... Ready to roast!")

        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            logger.info("Monitor stopped")

if __name__ == "__main__":
    try:
        main()
    except Exception:
        logger.exception("Code monitor crashed")
        raise

