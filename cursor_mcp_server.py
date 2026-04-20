#!/usr/bin/env python3
"""
TalkBack MCP Server - Monitors Cursor IDE for code execution results
Sends roasts to TalkBack avatar based on errors/success
"""

import asyncio
import json
import os
import subprocess
import sys
import time
import warnings
from typing import Any, Dict, List

warnings.filterwarnings("default", category=DeprecationWarning)
warnings.warn(
    "cursor_mcp_server.py is deprecated and will be removed in a future release. "
    "Use cursor_code_monitor.py or another /tmp/talkback_message.json writer instead.",
    DeprecationWarning,
    stacklevel=2,
)

from mcp import types
from mcp.server import NotificationOptions, Server
from mcp.server.models import InitializationOptions
from mcp.server.stdio import stdio_server

from cursor_code_monitor import (
    MAX_PROMPT_SIZE_BYTES,
    ROAST_ERROR_THRESHOLD,
    validate_message_fields,
)

# TalkBack MCP Server
app = Server("talkback-monitor")

# Global state to track code execution results
execution_results = {
    "last_run_time": None,
    "last_output": "",
    "error_count": 0,
    "linter_errors": [],
    "success": False
}


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

        lines: List[str] = []
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

        lines: List[str] = []
        for item in data:
            if isinstance(item, (dict, list)):
                lines.append(f"{space}-")
                lines.extend(to_yaml(item, indent + 2).rstrip("\n").split("\n"))
            else:
                lines.append(f"{space}- {yaml_scalar(item)}")
        return "\n".join(lines) + "\n"

    return f"{space}{yaml_scalar(data)}\n"

@app.list_resources()
async def handle_list_resources() -> list[types.Resource]:
    """List available resources from TalkBack monitor"""
    return [
        types.Resource(
            uri="talkback://execution-results",
            name="Latest Code Execution Results",
            description="Most recent code execution output and error count",
            mimeType="application/x-yaml"
        ),
        types.Resource(
            uri="talkback://linter-errors",
            name="Current Linter Errors",
            description="Active linter/compiler errors in the workspace",
            mimeType="application/x-yaml"
        )
    ]

@app.read_resource()
async def handle_read_resource(uri: str) -> str:
    """Read resource data"""
    if uri == "talkback://execution-results":
        return to_yaml(execution_results)
    elif uri == "talkback://linter-errors":
        return to_yaml({
            "linter_errors": execution_results["linter_errors"],
            "error_count": execution_results["error_count"]
        })
    else:
        raise ValueError(f"Unknown resource: {uri}")

@app.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    """List available tools"""
    return [
        types.Tool(
            name="report_code_execution",
            description="Report code execution results to trigger TalkBack roasting",
            inputSchema={
                "type": "object",
                "properties": {
                    "output": {
                        "type": "string",
                        "description": "Terminal output from code execution"
                    },
                    "error_count": {
                        "type": "integer",
                        "description": "Number of errors detected"
                    },
                    "linter_errors": {
                        "type": "array",
                        "description": "List of linter/compiler error messages",
                        "items": {"type": "string"}
                    },
                    "success": {
                        "type": "boolean",
                        "description": "Whether execution was successful"
                    }
                },
                "required": ["output", "error_count", "success"]
            }
        ),
        types.Tool(
            name="trigger_talkback_roast",
            description="Manually trigger TalkBack to roast based on current results",
            inputSchema={
                "type": "object",
                "properties": {
                    "force": {
                        "type": "boolean",
                        "description": "Force roast even if no recent execution"
                    }
                }
            }
        )
    ]

@app.call_tool()
async def handle_call_tool(
    name: str, arguments: dict[str, Any] | None
) -> list[types.TextContent | types.ImageContent | types.EmbeddedResource]:
    """Handle tool calls"""
    
    if name == "report_code_execution":
        # Update execution results
        execution_results["last_run_time"] = time.time()
        execution_results["last_output"] = arguments.get("output", "")
        execution_results["error_count"] = arguments.get("error_count", 0)
        execution_results["linter_errors"] = arguments.get("linter_errors", [])
        execution_results["success"] = arguments.get("success", False)
        
        # Generate roast message based on error count
        error_count = execution_results["error_count"]
        
        if error_count >= ROAST_ERROR_THRESHOLD:
            # ROAST MODE 🔥
            roast_prompt = f"ROAST ME HARD! My code just failed with {error_count} errors. Here's the output: {execution_results['last_output'][:500]}"
            response_type = "roast"
        elif error_count == 1:
            # Minor sass
            roast_prompt = f"I got 1 error. Give me a little attitude about it: {execution_results['last_output'][:300]}"
            response_type = "minor_sass"
        else:
            # Success with attitude
            roast_prompt = f"My code ran successfully! Tell me 'okay you made it this time' but with attitude and sass."
            response_type = "sassy_success"

        # Call TalkBack to speak
        await trigger_talkback_speech(roast_prompt, response_type)
        
        return [
            types.TextContent(
                type="text",
                text=to_yaml({
                    "status": "success",
                    "error_count": error_count,
                    "response_type": response_type,
                    "message": f"TalkBack triggered with {response_type}"
                }).rstrip()
            )
        ]
    
    elif name == "trigger_talkback_roast":
        force = arguments.get("force", False) if arguments else False
        
        if not execution_results["last_run_time"] and not force:
            return [
                types.TextContent(
                    type="text",
                    text="No recent code execution to roast about!"
                )
            ]
        
        error_count = execution_results["error_count"]
        roast_prompt = f"ROAST ME about my code with {error_count} errors!"
        await trigger_talkback_speech(roast_prompt, "roast")
        
        return [
            types.TextContent(
                type="text",
                text="TalkBack roast triggered!"
            )
        ]
    
    raise ValueError(f"Unknown tool: {name}")

async def trigger_talkback_speech(prompt: str, response_type: str):
    """Send prompt to TalkBack via HTTP or socket"""
    # For now, we'll write to a file that TalkBack monitors
    # In production, this would be a proper socket/HTTP connection

    talkback_message = {
        "prompt": prompt,
        "type": response_type,
        "timestamp": time.time()
    }
    talkback_message = validate_message_fields(talkback_message)

    # Write to a file that TalkBack monitors
    message_file = "/tmp/talkback_message.yaml"
    with open(message_file, "w") as f:
        f.write(to_yaml(talkback_message))

    print(f"🎤 TalkBack message sent: {response_type}", file=sys.stderr)

async def main():
    """Main entry point"""
    # Run the server using stdin/stdout streams
    async with stdio_server() as (read_stream, write_stream):
        await app.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="talkback-monitor",
                server_version="1.0.0",
                capabilities=app.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={}
                )
            )
        )

if __name__ == "__main__":
    asyncio.run(main())

