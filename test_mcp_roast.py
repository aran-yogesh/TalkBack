#!/usr/bin/env python3
"""
Simple MCP test - Trigger TalkBack roasts without dependencies
"""

import json
import re
import subprocess
import sys
import time


def count_errors_in_output(output: str) -> int:
    """Count errors in terminal output"""
    error_patterns = [
        r'error:',
        r'Error:',
        r'ERROR:',
        r'Traceback',
        r'SyntaxError',
        r'TypeError',
        r'ValueError',
        r'AttributeError',
        r'ImportError',
        r'NameError',
    ]
    
    error_count = 0
    for pattern in error_patterns:
        matches = re.findall(pattern, output, re.IGNORECASE)
        error_count += len(matches)
    
    return error_count


def send_to_talkback(output: str, error_count: int, success: bool):
    """Send code execution results to TalkBack"""
    
    # Determine response type
    if error_count >= 2:
        response_type = "roast"
        prompt = f"ROAST ME HARD! My code just failed with {error_count} errors! Here's the disaster: {output[:400]}"
    elif error_count == 1:
        response_type = "minor_sass"
        prompt = f"I got 1 error in my code. Give me some sass about it: {output[:250]}"
    else:
        response_type = "sassy_success"
        prompt = "My code actually ran successfully! Give me a sassy compliment with attitude!"
    
    # Create message for TalkBack
    message = {
        "prompt": prompt,
        "type": response_type,
        "timestamp": time.time(),
        "error_count": error_count,
        "success": success
    }
    
    # Write to file that TalkBack monitors
    message_file = "/tmp/talkback_message.json"
    try:
        with open(message_file, "w") as f:
            json.dump(message, f, indent=2)
        
        print(f"✅ Sent to TalkBack: {response_type} (errors: {error_count})")
        print(f"🎤 TalkBack should roast you in 3... 2... 1... 🔥")
    except Exception as e:
        print(f"❌ Error sending to TalkBack: {e}")


def run_command(command: str):
    """Run a command and monitor its output"""
    print(f"🔍 Running command: {command}")
    print("")
    
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
        error_count = count_errors_in_output(output)
        success = result.returncode == 0 and error_count == 0
        
        print(f"📊 Command finished:")
        print(f"   - Return code: {result.returncode}")
        print(f"   - Errors detected: {error_count}")
        print(f"   - Success: {success}")
        print("")
        print(f"📄 Output:")
        print(output[:500] if len(output) > 500 else output)
        print("")
        
        # Send to TalkBack
        send_to_talkback(output, error_count, success)
        
    except subprocess.TimeoutExpired:
        print("⏱️  Command timed out")
        send_to_talkback("Command timed out!", 1, False)
    except Exception as e:
        print(f"❌ Error running command: {e}")
        send_to_talkback(str(e), 1, False)


def main():
    print("🤖 TalkBack MCP Roast Tester")
    print("=" * 50)
    print("")
    
    if len(sys.argv) < 2:
        print("Usage: python3 test_mcp_roast.py '<command>'")
        print("")
        print("Examples:")
        print("  python3 test_mcp_roast.py 'python3 test_with_errors.py'")
        print("  python3 test_mcp_roast.py 'swift broken_code.swift'")
        print("  python3 test_mcp_roast.py 'echo Success'")
        sys.exit(1)
    
    command = " ".join(sys.argv[1:])
    run_command(command)


if __name__ == "__main__":
    main()

