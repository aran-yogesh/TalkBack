#!/usr/bin/env python3
"""
Intentionally broken code to test TalkBack roasting

.. deprecated::
    This test fixture is deprecated. MCP monitoring is now built directly
    into ConversationalTalkBack.swift and no longer requires external scripts.
"""
import warnings

warnings.warn(
    "broken_code.py is deprecated. "
    "MCP roast testing is now handled natively by ConversationalTalkBack.swift.",
    DeprecationWarning,
    stacklevel=2,
)

# Error 1: NameError - undefined variable
print(undefined_variable)

# Error 2: TypeError - string + int
result = "hello" + 5

# Error 3: ZeroDivisionError
answer = 10 / 0

print("This will never run")


