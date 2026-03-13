#!/usr/bin/env python3
"""
Test script to verify MCP server connection
"""

import json
import subprocess
import sys
import time
from typing import Any


def yaml_scalar(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if value is None:
        return "null"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    return json.dumps(str(value), ensure_ascii=False)


def to_yaml(data: Any, indent: int = 0) -> str:
    space = " " * indent

    if isinstance(data, dict):
        if not data:
            return f"{space}{{}}\n"

        lines: list[str] = []
        for key, value in data.items():
            key_text = str(key)
            if isinstance(value, dict):
                if value:
                    lines.append(f"{space}{key_text}:")
                    lines.extend(to_yaml(value, indent + 2).rstrip("\n").split("\n"))
                else:
                    lines.append(f"{space}{key_text}: {{}}")
            elif isinstance(value, list):
                if value:
                    lines.append(f"{space}{key_text}:")
                    lines.extend(to_yaml(value, indent + 2).rstrip("\n").split("\n"))
                else:
                    lines.append(f"{space}{key_text}: []")
            else:
                lines.append(f"{space}{key_text}: {yaml_scalar(value)}")
        return "\n".join(lines) + "\n"

    if isinstance(data, list):
        if not data:
            return f"{space}[]\n"

        lines: list[str] = []
        for item in data:
            if isinstance(item, (dict, list)):
                lines.append(f"{space}-")
                lines.extend(to_yaml(item, indent + 2).rstrip("\n").split("\n"))
            else:
                lines.append(f"{space}- {yaml_scalar(item)}")
        return "\n".join(lines) + "\n"

    return f"{space}{yaml_scalar(data)}\n"


def test_mcp_server():
    """Test the MCP server by sending a test message"""
    
    # Test message to send to TalkBack
    test_message = {
        "prompt": "Test message from MCP server! Your code monitoring is working! 🎉",
        "type": "test",
        "timestamp": time.time()
    }
    
    # Write to the file that TalkBack monitors
    message_file = "/tmp/talkback_message.yaml"
    with open(message_file, "w") as f:
        f.write(to_yaml(test_message))
    
    print("✅ Test message sent to TalkBack!")
    print(f"📁 Message file: {message_file}")
    print(f"📝 Message content:\n{to_yaml(test_message).rstrip()}")
    
    return True

if __name__ == "__main__":
    test_mcp_server()
