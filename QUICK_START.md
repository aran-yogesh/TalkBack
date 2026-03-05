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
./ConversationalTalkBack
```

### 2️⃣ Test the Roasting

```bash
# Trigger a savage roast (broken_code.py has intentional errors)
python3 cursor_code_monitor.py run 'python3 broken_code.py'

# Test sassy success
python3 cursor_code_monitor.py run 'echo "Hello World"'
```

### 3️⃣ Run Your Code with Monitoring

```bash
# Python
python3 cursor_code_monitor.py run 'python your_script.py'

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
| `ConversationalTalkBack.swift` | Main TalkBack avatar with MCP monitoring |
| `config.swift.template` | API key template (copy to `config.swift`) |
| `cursor_code_monitor.py` | Monitors code execution, counts errors |
| `cursor_mcp_server.py` | MCP server for Cursor integration |
| `test_mcp_connection.py` | Verifies MCP message pipeline |
| `broken_code.py` | Test script with intentional errors |
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
