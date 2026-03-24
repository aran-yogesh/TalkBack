# TalkBack + Cursor MCP - Quick Start 🚀

## 🎯 What You Just Got

TalkBack now watches your code in Cursor IDE and roasts you when you mess up! 🔥

### Roasting Rules:
- **2+ errors** → FULL ROAST MODE 🔥🔥🔥
- **1 error** → Light sass 😏
- **0 errors** → Sassy success 💅

---

## ⚡ Quick Start (3 Steps)

### 1️⃣ Start TalkBack Avatar

```bash
swiftc -o ConversationalTalkBack ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0

./ConversationalTalkBack
```

### 2️⃣ Test the Roasting

```bash
# Trigger a savage roast (broken_code.py has intentional errors)
python3 cursor_code_monitor.py run 'python3 broken_code.py'

# Test with a passing command
python3 cursor_code_monitor.py run 'echo "Hello World"'
```

### 3️⃣ Run Your Code with Monitoring

```bash
# Python
python3 cursor_code_monitor.py run 'python3 your_script.py'

# Swift
python3 cursor_code_monitor.py run 'swift your_file.swift'

# npm/node
python3 cursor_code_monitor.py run 'npm test'

# Any command
python3 cursor_code_monitor.py run 'YOUR_COMMAND'
```

---

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `ConversationalTalkBack.swift` | Main TalkBack avatar with voice, Lens, teacher mode, and MCP monitoring |
| `cursor_code_monitor.py` | Monitors code execution, counts errors, writes to `/tmp/talkback_message.yaml` |
| `cursor_mcp_server.py` | MCP server for Cursor integration |
| `broken_code.py` | Intentionally broken script for testing roasts |
| `test_mcp_connection.py` | Verifies the IPC message file works |
| `config.swift.template` | API key template (copy to `config.swift`) |
| `MCP_SETUP.md` | Detailed setup guide |

---

## 🎤 What Ivanna Will Say

### Success (0 errors):
> "Oh wow, it ACTUALLY worked? Color me shocked, darling! Don't get cocky now. 💅✨"

### 1 Error:
> "ONE error? Cute. At least you're almost there, sweetheart. 😏"

### 2+ Errors (ROAST MODE):
> "OH HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀 Try again, but this time with SKILL!"

---

## 🔗 More Info

See the full [README.md](README.md) for all features, API details, and troubleshooting.
