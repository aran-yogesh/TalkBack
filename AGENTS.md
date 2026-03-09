# Agent Guide

This file gives quick context and working rules for AI coding agents in this repository.

## Project Overview

- App: `TalkBack` (macOS floating AI companion with voice + vision features).
- Primary runtime file: `ConversationalTalkBack.swift`.
- Supporting scripts and integration files are mainly Python and shell.

## Common Workflows

- Build app:
  - `swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift -framework Cocoa -framework Foundation -framework AVFoundation -target arm64-apple-macosx13.0`
- Run app:
  - `./ConversationalTalkBack`
- MCP integration checks:
  - `python3 test_mcp_connection.py`
  - `python3 cursor_code_monitor.py run 'python3 broken_code.py'`

## Editing Guidelines

- Keep changes focused and minimal.
- Do not commit secrets or API keys.
- Prefer updating docs when behavior or setup changes.
- Avoid destructive git commands unless explicitly requested.

## README.md Guidelines

- Always include a `Table of Contents` section in `README.md` for quick navigation.
- Update the table of contents whenever headings are added, removed, or renamed.
- Update `README.md` whenever setup, commands, features, or user-visible behavior changes.
- Keep `Quick Start`, prerequisites, and troubleshooting steps aligned with current code.
- Ensure all command snippets are copy-paste ready and valid from repo root unless noted.
- When adding new scripts or integrations, add at least one concrete usage example.
- Use concise, actionable language and avoid vague instructions.
- If no README changes are needed for a code change, explicitly state why in your task notes.

## Validation Checklist

- Confirm Swift and Python scripts still run after edits.
- Verify docs commands remain accurate.
- Check for obvious lint/type/runtime errors in edited files.
