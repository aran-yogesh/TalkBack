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
cd /Users/aran/Desktop/talkback
./start_talkback_mcp.sh
```

### 2️⃣ Test the Roasting

```bash
# Test sassy success (0 errors)
python3 test_roast.py 1

# Test minor sass (1 error)
python3 test_roast.py 2

# Test FULL ROAST (2+ errors)
python3 test_roast.py 3
```

### 3️⃣ Run Your Code with Monitoring

```bash
# Python
python3 cursor_code_monitor.py run "python your_script.py"

# Swift
python3 cursor_code_monitor.py run "swift your_file.swift"

# npm/node
python3 cursor_code_monitor.py run "npm test"

# Any command
python3 cursor_code_monitor.py run "YOUR_COMMAND"
```

---

## 🧪 Demo Scripts

### Test with Success (0 errors)
```bash
python3 cursor_code_monitor.py run "python test_with_errors.py success"
```
**Expected**: "Okay you made it this time, darling! 💅"

### Test with 1 Error
```bash
python3 cursor_code_monitor.py run "python test_with_errors.py one_error"
```
**Expected**: "ONE error? Cute. 😏"

### Test with Multiple Errors (ROAST MODE)
```bash
python3 cursor_code_monitor.py run "python test_with_errors.py roast"
```
**Expected**: "OH HONEY, what is this hot mess?! 🔥💀"

---

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `MCPTalkBack.swift` | Main TalkBack avatar with MCP monitoring |
| `MCPTalkBack` | Compiled binary (run this!) |
| `cursor_code_monitor.py` | Monitors code execution, counts errors |
| `cursor_mcp_server.py` | MCP server for Cursor integration |
| `test_roast.py` | Manual roast trigger (testing) |
| `test_with_errors.py` | Demo script with intentional errors |
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

---

## 🛠️ Troubleshooting

### TalkBack not speaking?
```bash
# Check if running
ps aux | grep MCPTalkBack

# Restart
pkill MCPTalkBack
./start_talkback_mcp.sh
```

### Roasts not triggering?
```bash
# Check message file exists
cat /tmp/talkback_message.json

# Try manual test
python3 test_roast.py 3
```

### Python dependencies missing?
```bash
pip3 install mcp watchdog
```

---

## 🎯 Next Steps

1. **Try the demos** above to see TalkBack in action
2. **Run your real code** with the monitor
3. **Get roasted** and improve! 🔥
4. **Share your roasts** (they're hilarious)

---

## 📖 More Info

- **Detailed Setup**: See [MCP_SETUP.md](MCP_SETUP.md)
- **Main README**: See [README.md](README.md)
- **GitHub**: https://github.com/aran-yogesh/TalkBack

---

**Now go code and get roasted! 🔥**

Made with 💻 and a lot of sass by [@aran-yogesh](https://github.com/aran-yogesh)

