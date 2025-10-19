#!/usr/bin/env python3
"""
Test script with intentional errors for TalkBack roasting demo
"""

import sys


def main():
    if len(sys.argv) > 1:
        mode = sys.argv[1]
    else:
        mode = "success"
    
    if mode == "success":
        # No errors - sassy success
        print("✅ Code ran successfully!")
        print("Everything is working perfectly.")
        return 0
    
    elif mode == "one_error":
        # 1 error - minor sass
        print("⚠️  Running with 1 error...")
        undefined_variable = x  # NameError
        return 1
    
    elif mode == "roast":
        # Multiple errors - full roast mode
        print("💥 Running with multiple errors...")
        
        # Error 1: NameError
        result = undefined_var + 10
        
        # Error 2: TypeError
        number = "5" + 5
        
        # Error 3: ZeroDivisionError
        division = 10 / 0
        
        return 1
    
    else:
        print("Usage: python test_with_errors.py [success|one_error|roast]")
        return 1

if __name__ == "__main__":
    sys.exit(main())

