# Agent Guide

This file gives quick context and working rules for AI coding agents in this repository.

## Project Overview

- App: `TalkBack` (macOS floating AI companion with voice + vision features).
- Primary runtime file: `ConversationalTalkBack.swift`.
- Supporting scripts and integration files are mainly Python and shell.

## Common Workflows

- Build app:
  - `swiftc -o ConversationalTalkBack ConversationalTalkBack.swift -framework Cocoa -framework Foundation -framework AVFoundation -target arm64-apple-macosx13.0`
- Run app:
  - `./ConversationalTalkBack`
- MCP integration checks:
  - `python3 test_mcp_connection.py`
  - `python3 test_mcp_roast.py 'python3 broken_code.py'`

## Editing Guidelines

- Keep changes focused and minimal.
- Do not commit secrets or API keys.
- Prefer updating docs when behavior or setup changes.
- Avoid destructive git commands unless explicitly requested.

## Validation Checklist

- Confirm Swift and Python scripts still run after edits.
- Verify docs commands remain accurate.
- Check for obvious lint/type/runtime errors in edited files.
