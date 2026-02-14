# Deprecation Warnings

This document tracks deprecated dependencies, APIs, and patterns across the TalkBack project. These should be addressed in future releases.

---

## Python (MCP Server & Monitor)

| File | Issue | Migration Path |
|------|-------|---------------|
| `cursor_mcp_server.py` | Uses legacy `Server`, `InitializationOptions`, `NotificationOptions`, and manual `stdio_server()` pattern from the MCP SDK. | Migrate to `FastMCP` API: `from mcp.server.fastmcp import FastMCP; mcp = FastMCP('talkback-monitor'); mcp.run()` |
| `cursor_code_monitor.py` | `watchdog.observers.Observer` is imported but never used. | Remove unused import or implement file-watching logic. |
| `cursor_code_monitor.py` | `subprocess.run(shell=True)` is a security risk with untrusted input. | Use `subprocess.run(shlex.split(command))` instead. |

## Swift (ConversationalTalkBack)

| Location | Issue | Migration Path |
|----------|-------|---------------|
| `ConversationalAvatarView` | `AVSpeechSynthesizer` is declared but unused — TTS is handled by ElevenLabs. | Remove `speechSynthesizer` property. |
| `ConversationalAvatarView` | `NSSoundDelegate` conformance is unused — audio playback uses `AVAudioPlayer`. | Remove `NSSoundDelegate` from class declaration. |
| `applicationDidFinishLaunching` | `NSApp.activate(ignoringOtherApps: true)` is deprecated in macOS 14.0+. | Replace with `NSApp.activate()`. |
| `ensureAccessibilityPermission` | `kAXTrustedCheckOptionPrompt.takeRetainedValue()` is a deprecated CF bridging pattern. | Use `kAXTrustedCheckOptionPrompt as String` directly. |

## Shell Scripts

| File | Issue | Migration Path |
|------|-------|---------------|
| `start_integration.sh` | Previously used `python` and `pip` instead of `python3` and `pip3`. | Fixed — now uses `python3` / `pip3`. |

## npm Dependencies (`package.json`)

| Package | Status | Replacement |
|---------|--------|------------|
| `moment` (^2.29.4) | Maintenance mode / deprecated | Use `date-fns` (already present) or `dayjs` (already present). |
| `@mui/joy` (5.0.0-alpha.84) | Discontinued — merged into Material UI | Migrate to `@mui/material`. |
| `@mui/base` (5.0.0-beta.4) | Superseded | Migrate to `@base-ui/react`. |
| `@codemirror/text` (^0.19.6) | Merged into `@codemirror/state` in CodeMirror 6.0 | Remove and use `@codemirror/state` (already present). |
| `@codemirror/legacy-modes` (^6.5.1) | Legacy migration package | Remove once all modes are migrated to CodeMirror 6 native. |
| `reactflow` (^11.11.2) | Renamed | Migrate to `@xyflow/react`. |
| `ajv` (^6.12.6) | Major version behind (v8 is current) | Upgrade to `ajv` v8. |
| `jose` (^4.15.5) | Major version behind (v5 is current) | Upgrade to `jose` v5. |
| `prettier` (^2.8.8) | Major version behind (v3 is current) | Upgrade to `prettier` v3. |
| `zustand` (^5.0.0-rc.2) | Pre-release / release candidate | Pin to a stable release. |
| `@types/date-fns` (^2.6.0) | Deprecated — `date-fns` v4 ships its own types | Remove `@types/date-fns`. |
| `@types/react-router-dom` (^5.3.3) | Deprecated — React Router v6 ships its own types | Remove `@types/react-router-dom`. |
