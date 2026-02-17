# Deprecation Warnings

This document tracks deprecated features, dependencies, and patterns in the TalkBack project.

## Swift — `AVSpeechSynthesizer` (ConversationalTalkBack.swift)

**Status:** Deprecated  
**Replacement:** `speakWithElevenLabs()`  

The built-in `AVSpeechSynthesizer` property is no longer used. All text-to-speech
is now handled by ElevenLabs TTS via the `speakWithElevenLabs()` method. The
property is annotated with `@available(*, deprecated)` and will be removed in a
future release.

## Python — File-Based IPC (cursor_mcp_server.py, cursor_code_monitor.py)

**Status:** Deprecated  
**Replacement:** Socket or HTTP-based transport  

Both `trigger_talkback_speech()` in `cursor_mcp_server.py` and
`send_to_talkback()` in `cursor_code_monitor.py` communicate with the TalkBack
avatar by writing JSON to `/tmp/talkback_message.json`. This file-based IPC
mechanism is fragile and intended only for prototyping. A `DeprecationWarning` is
now emitted at runtime whenever these functions are called. Migrate to a proper
socket or HTTP connection.

## Shell — `start_talkback_mcp.sh` References Non-Existent `MCPTalkBack.swift`

**Status:** Deprecated  
**Replacement:** Update script to compile `ConversationalTalkBack.swift`  

The starter script references `MCPTalkBack.swift`, which no longer exists in the
repository. The main Swift source file has been renamed to
`ConversationalTalkBack.swift`. A deprecation warning is now printed when the
script runs.

## Node.js — Deprecated Dependencies (package.json)

The following dependencies are deprecated or have been superseded. They should be
replaced when practical:

| Package | Issue | Replacement |
|---------|-------|-------------|
| `moment` (^2.29.4) | Officially in maintenance mode by its maintainers | `date-fns` (already present) or `dayjs` (already present) |
| `@codemirror/text` (^0.19.6) | Pre-1.0 package from CodeMirror 6 early development | `@codemirror/state` (already present) |
| `jose` (^4.15.5) | v4 is deprecated | `jose` v5+ |
| `reactflow` (^11.11.2) | Package has been renamed | `@xyflow/react` |
| `@types/date-fns` (^2.6.0) | date-fns v4 ships its own types | Remove this package |
| `@mui/joy` (5.0.0-alpha.84) | Alpha package with uncertain future | `@mui/material` |
| `@mui/base` (5.0.0-beta.4) | Beta package, being restructured | `@mui/material` |
