#!/usr/bin/env python3
"""
Cursor Code Monitor - Watches for code execution and triggers TalkBack roasts
This script monitors terminal output and linter errors, then sends to TalkBack
"""

import json
import os
import re
import shlex
import subprocess
import sys
import time
from pathlib import Path

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

from talkback_utils import MESSAGE_FILE, build_message, write_message_atomic


class CodeExecutionMonitor(FileSystemEventHandler):
    def __init__(self, talkback_message_file=None):
        self.talkback_message_file = talkback_message_file or MESSAGE_FILE
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
        """Send code execution results to TalkBack."""
        if error_count >= 2:
            response_type = "roast"
            prompt = f"ROAST ME! My code failed with {error_count} errors! Here's what happened: {output[:500]}"
        elif error_count == 1:
            response_type = "minor_sass"
            prompt = f"I got 1 error in my code. Give me a little sass: {output[:300]}"
        else:
            response_type = "sassy_success"
            prompt = "My code ran successfully! Tell me 'okay you made it this time' but with major attitude!"

        message = build_message(
            prompt, response_type, error_count=error_count, success=success
        )

        try:
            write_message_atomic(message, self.talkback_message_file)
            print(f"✅ Sent to TalkBack: {response_type} (errors: {error_count})")
        except Exception as e:
            print(f"❌ Error sending to TalkBack: {e}")
    
    def monitor_terminal_command(self, command: str):
        """Run a command and monitor its output"""
        print(f"🔍 Monitoring command: {command}")
        
        try:
            result = subprocess.run(
                shlex.split(command),
                capture_output=True,
                text=True,
                timeout=30
            )
            
            output = result.stdout + result.stderr
            error_count = self.count_errors_in_output(output)
            success = result.returncode == 0 and error_count == 0
            
            print(f"📊 Command finished: {error_count} errors, success={success}")
            print(f"📄 Output preview: {output[:200]}")
            
            # Send to TalkBack
            self.send_to_talkback(output, error_count, success)
            
        except subprocess.TimeoutExpired:
            print("⏱️  Command timed out")
            self.send_to_talkback("Command timed out!", 1, False)
        except Exception as e:
            print(f"❌ Error running command: {e}")
            self.send_to_talkback(str(e), 1, False)

def main():
    print("🤖 TalkBack Cursor Monitor Started!")
    print("   - Monitoring your code execution")
    print("   - Will trigger TalkBack roasts on errors")
    print("")
    
    monitor = CodeExecutionMonitor()
    
    # Example usage - you can customize this
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
        
        # Keep running to monitor (you can extend this with file watching)
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("\n👋 Monitor stopped")

if __name__ == "__main__":
    main()

