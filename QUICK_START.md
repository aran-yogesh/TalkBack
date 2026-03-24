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
./start_talkback_mcp.sh
```

### 2️⃣ Test the Roasting

```bash
# Test FULL ROAST (2+ errors)
python3 cursor_code_monitor.py run 'python3 broken_code.py'

# Test sassy success (0 errors)
python3 cursor_code_monitor.py run 'echo Hello World'
```

### 3️⃣ Run Your Code with Monitoring

```bash
# Python
python3 cursor_code_monitor.py run "python3 your_script.py"

# Swift
python3 cursor_code_monitor.py run "swift your_file.swift"

# npm/node
python3 cursor_code_monitor.py run "npm test"

# Any command
python3 cursor_code_monitor.py run "YOUR_COMMAND"
```

---

## 🧪 Demo

### Test with Broken Code (ROAST MODE)
```bash
python3 cursor_code_monitor.py run 'python3 broken_code.py'
```
**Expected**: "OH HONEY, what is this hot mess?! 🔥💀"

### Test with Success
```bash
python3 cursor_code_monitor.py run 'echo Success!'
```
**Expected**: "Okay you made it this time, darling! 💅"

---

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `ConversationalTalkBack.swift` | Main TalkBack avatar with MCP monitoring |
| `cursor_code_monitor.py` | Monitors code execution, counts errors |
| `cursor_mcp_server.py` | MCP server for Cursor integration |
| `broken_code.py` | Intentionally broken script for testing roasts |
| `start_talkback_mcp.sh` | Easy start script |
| `MCP_SETUP.md` | Detailed setup guide |

---

## 🎤 What Ivanna Will Say

### Success (0 errors):
> "Oh wow, it ACTUALLY worked? Color me shocked, darling! Don't get cocky now. 💅✨"

### 1 Error:
> "ONE error? Cute. At least you're almost there, sweetheart. 😏"

### 2+ Errors (ROAST MODE):
> "OH HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀 Try again, but this time with SKILL!"
