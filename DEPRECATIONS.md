# Deprecation Notices

## Python Modules

### `cursor_code_monitor.py`
**Status:** Deprecated  
**Replacement:** Use the MCP-based `cursor_mcp_server.py` instead.  
This module uses the legacy file-watching approach and will be removed in a future release.

### `test_mcp_connection.py`
**Status:** Deprecated  
**Replacement:** Use the MCP server integration tests instead.  
This script was a temporary test harness and will be removed in a future release.

### `cursor_mcp_server.py`
**Status:** Experimental  
The MCP server API (`InitializationOptions`, `NotificationOptions`) is experimental and may change in future versions of the `mcp` package.

## Swift

### `AVSpeechSynthesizer` in `ConversationalTalkBack.swift`
**Status:** Deprecated  
**Replacement:** Use ElevenLabs TTS via `speakWithElevenLabs`.  
The built-in `AVSpeechSynthesizer` property is unused dead code from a previous implementation.

### `NSApp.activate(ignoringOtherApps:)` in `ConversationalTalkBack.swift`
**Status:** Deprecated in macOS 14 (Sonoma)  
**Replacement:** `NSApp.activate()` (no parameter). The code now uses `#available` to call the correct API based on the macOS version.

## npm Packages (`package.json`)

### `@codemirror/text` (^0.19.6)
**Status:** Deprecated  
**Replacement:** Merged into `@codemirror/state` in CodeMirror 6.0. Remove this dependency and use `@codemirror/state` instead.

### `moment` (^2.29.4)
**Status:** Maintenance mode (legacy)  
**Replacement:** Use `date-fns` or `dayjs`, both of which are already in the dependencies.

### `@types/date-fns` (^2.6.0)
**Status:** Deprecated  
**Replacement:** `date-fns` v2+ ships its own TypeScript types. Remove this package.

### `ajv` (^6.12.6)
**Status:** Legacy  
**Replacement:** Upgrade to `ajv` v8. The v6 line only receives security patches.

### `zustand` (^5.0.0-rc.2)
**Status:** Pre-release  
**Action:** Upgrade to stable `zustand` v5 when available.

### `react-resizable-panels` (^0.0.55)
**Status:** Pre-1.0 unstable API  
**Action:** Monitor for a stable 1.0 release and upgrade.
