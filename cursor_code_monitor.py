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

TALKBACK_MESSAGE_FILE = "/tmp/talkback_message.json"
DEFAULT_COMMAND_TIMEOUT = 30

ERROR_PATTERNS = [
    r'error:',
    r'compilation failed',
    r'build failed',
    r'test failed',
    r'exception',
    r'Traceback',
    r'SyntaxError',
    r'TypeError',
    r'ValueError',
    r'AttributeError',
    r'ImportError',
    r'ModuleNotFoundError',
]


class CodeExecutionMonitor:
    def __init__(self, talkback_message_file: str = TALKBACK_MESSAGE_FILE) -> None:
        self.talkback_message_file = talkback_message_file
        self.last_error_count = 0

    def count_errors_in_output(self, output: str) -> int:
        """Count distinct error occurrences in terminal output."""
        if not output:
            return 0

        error_count = 0
        for pattern in ERROR_PATTERNS:
            error_count += len(re.findall(pattern, output, re.IGNORECASE))

        return error_count
    
    def send_to_talkback(self, output: str, error_count: int, success: bool) -> None:
        """Send code execution results to TalkBack."""
        if not isinstance(error_count, int) or error_count < 0:
            error_count = 0

        if error_count >= 2:
            response_type = "roast"
            prompt = f"ROAST ME! My code failed with {error_count} errors! Here's what happened: {output[:500]}"
        elif error_count == 1:
            response_type = "minor_sass"
            prompt = f"I got 1 error in my code. Give me a little sass: {output[:300]}"
        else:
            response_type = "sassy_success"
            prompt = "My code ran successfully! Tell me 'okay you made it this time' but with major attitude!"

        message = {
            "prompt": prompt,
            "type": response_type,
            "timestamp": time.time(),
            "error_count": error_count,
            "success": success
        }

        try:
            with open(self.talkback_message_file, "w") as f:
                json.dump(message, f, indent=2)
            print(f"✅ Sent to TalkBack: {response_type} (errors: {error_count})")
        except OSError as e:
            print(f"❌ Error sending to TalkBack: {e}")
    
    def monitor_terminal_command(self, command: str, timeout: int = DEFAULT_COMMAND_TIMEOUT) -> None:
        """Run a command and monitor its output."""
        if not command or not command.strip():
            print("❌ Empty command provided")
            return

        print(f"🔍 Monitoring command: {command}")

        try:
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                timeout=timeout,
            )

            output = result.stdout + result.stderr
            error_count = self.count_errors_in_output(output)
            success = result.returncode == 0 and error_count == 0

            self.last_error_count = error_count
            print(f"📊 Command finished: {error_count} errors, success={success}")
            print(f"📄 Output preview: {output[:200]}")

            self.send_to_talkback(output, error_count, success)

        except subprocess.TimeoutExpired:
            print("⏱️  Command timed out")
            self.send_to_talkback("Command timed out!", 1, False)
        except OSError as e:
            print(f"❌ Error running command: {e}")
            self.send_to_talkback(str(e), 1, False)

def main() -> None:
    """CLI entry point for the code monitor."""
    print("🤖 TalkBack Cursor Monitor Started!")
    print("   - Monitoring your code execution")
    print("   - Will trigger TalkBack roasts on errors")
    print("")

    monitor = CodeExecutionMonitor()

    print("📝 Usage examples:")
    print("   1. Run Python: python cursor_code_monitor.py run 'python your_script.py'")
    print("   2. Run Swift: python cursor_code_monitor.py run 'swift your_file.swift'")
    print("   3. Run tests: python cursor_code_monitor.py run 'npm test'")
    print("")

    if len(sys.argv) > 2 and sys.argv[1] == "run":
        command = " ".join(sys.argv[2:])
        monitor.monitor_terminal_command(command)
    else:
        print("💡 Tip: Run this script with 'run' followed by your command")
        print("   Example: python cursor_code_monitor.py run 'python test.py'")
        print("")
        print("🎤 TalkBack is watching... Ready to roast! 🔥")

        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("\n👋 Monitor stopped")

if __name__ == "__main__":
    main()

