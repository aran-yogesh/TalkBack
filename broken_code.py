#!/usr/bin/env python3
"""Intentionally broken script used to trigger TalkBack roast responses.

Every statement below raises a different exception (NameError, TypeError,
ZeroDivisionError) so that the TalkBack monitor can detect multiple errors
and fire its roast / sass pipeline during integration testing.
"""

# Error 1: NameError - undefined variable
print(undefined_variable)

# Error 2: TypeError - string + int
result = "hello" + 5

# Error 3: ZeroDivisionError
answer = 10 / 0

print("This will never run")


