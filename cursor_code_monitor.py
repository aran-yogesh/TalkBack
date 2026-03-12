#!/usr/bin/env python3
"""
Cursor Code Monitor - Watches for code execution and triggers TalkBack roasts
This script monitors terminal output and linter errors, then sends to TalkBack
"""

import fcntl
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer


class CodeExecutionMonitor(FileSystemEventHandler):
    def __init__(self, talkback_message_file="/tmp/talkback_message.json"):
        self.talkback_message_file = talkback_message_file
        self.last_error_count = 0
        self.monitoring = True
        self._message_sequence = 0
        
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
        """Send code execution results to TalkBack via atomic file write."""
        if error_count >= 2:
            response_type = "roast"
            prompt = f"ROAST ME! My code failed with {error_count} errors! Here's what happened: {output[:500]}"
        elif error_count == 1:
            response_type = "minor_sass"
            prompt = f"I got 1 error in my code. Give me a little sass: {output[:300]}"
        else:
            response_type = "sassy_success"
            prompt = "My code ran successfully! Tell me 'okay you made it this time' but with major attitude!"

        self._message_sequence += 1
        message = {
            "prompt": prompt,
            "type": response_type,
            "timestamp": time.time(),
            "seq": self._message_sequence,
            "error_count": error_count,
            "success": success,
        }

        self._atomic_write(message)

    def _atomic_write(self, payload: dict, retries: int = 2):
        """Write JSON payload atomically using temp-file + rename with retries."""
        msg_dir = os.path.dirname(self.talkback_message_file) or "/tmp"
        last_err = None
        for attempt in range(1 + retries):
            fd, tmp_path = tempfile.mkstemp(dir=msg_dir, suffix=".json.tmp")
            try:
                with os.fdopen(fd, "w") as f:
                    fcntl.flock(f, fcntl.LOCK_EX)
                    json.dump(payload, f, indent=2)
                    f.flush()
                    os.fsync(f.fileno())
                os.rename(tmp_path, self.talkback_message_file)
                print(f"✅ Sent to TalkBack: {payload.get('type', '?')} (errors: {payload.get('error_count', '?')})")
                return
            except Exception as e:
                last_err = e
                try:
                    os.unlink(tmp_path)
                except OSError:
                    pass
                if attempt < retries:
                    time.sleep(0.1)
        print(f"❌ Error sending to TalkBack after {1 + retries} attempts: {last_err}")
    
    def monitor_terminal_command(self, command: str):
        """Run a command and monitor its output"""
        print(f"🔍 Monitoring command: {command}")
        
        try:
            # Run command and capture output
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

