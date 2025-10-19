#!/usr/bin/env python3
"""
Test script to trigger TalkBack roasts
"""

import json
import time


def trigger_roast(error_count: int, output: str = ""):
    """Trigger TalkBack roast with specified error count"""
    
    if error_count >= 2:
        response_type = "roast"
        prompt = f"ROAST ME! My code failed with {error_count} errors! {output}"
    elif error_count == 1:
        response_type = "minor_sass"
        prompt = f"I got 1 error in my code. Give me a little sass. {output}"
    else:
        response_type = "sassy_success"
        prompt = "My code ran successfully! Tell me 'okay you made it this time' but with attitude!"
    
    message = {
        "prompt": prompt,
        "type": response_type,
        "timestamp": time.time(),
        "error_count": error_count,
        "success": error_count == 0
    }
    
    message_file = "/tmp/talkback_message.json"
    with open(message_file, "w") as f:
        json.dump(message, f, indent=2)
    
    print(f"✅ Triggered {response_type} (errors: {error_count})")
    print(f"📄 Message: {prompt[:100]}...")

if __name__ == "__main__":
    import sys
    
    print("🧪 TalkBack Roast Tester")
    print("")
    print("Choose a test:")
    print("1. Success (0 errors) - Sassy success 💅")
    print("2. Minor error (1 error) - Light sass 😏")
    print("3. ROAST MODE (2+ errors) - Full roast 🔥")
    print("")
    
    if len(sys.argv) > 1:
        choice = sys.argv[1]
    else:
        choice = input("Enter choice (1-3): ")
    
    if choice == "1":
        print("\n💅 Testing SASSY SUCCESS...")
        trigger_roast(0, "Code compiled and ran perfectly!")
    elif choice == "2":
        print("\n😏 Testing MINOR SASS...")
        trigger_roast(1, "Error: Undefined variable 'x' at line 42")
    elif choice == "3":
        print("\n🔥 Testing FULL ROAST MODE...")
        trigger_roast(5, "Error: Syntax error at line 10. Error: Type mismatch at line 25. Error: Missing semicolon at line 30.")
    else:
        print("❌ Invalid choice!")
        sys.exit(1)
    
    print("")
    print("🎤 Check TalkBack avatar for the roast!")
    print("   (Make sure MCPTalkBack is running)")

