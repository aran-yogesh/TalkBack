# MCP Integration Guide 🔥

## Overview

TalkBack includes **MCP (Model Context Protocol) Code Monitoring** that watches your terminal for code execution results and automatically roasts you when your code fails!

This feature integrates with your Cursor IDE workflow without disturbing any existing functionality.

---

## 🎯 How It Works

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Cursor IDE Terminal                        │
│  (You run: python test.py, swift code.swift, etc.)          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│         cursor_code_monitor.py (Monitor Script)             │
│  - Captures terminal output                                 │
│  - Counts errors (Traceback, SyntaxError, etc.)             │
│  - Determines roast type (roast/minor_sass/sassy_success)   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│          /tmp/talkback_message.json (IPC File)              │
│  {                                                          │
│    "prompt": "ROAST ME! 5 errors...",                       │
│    "type": "roast",                                         │
│    "timestamp": 1234567890.123,                             │
│    "error_count": 5                                         │
│  }                                                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           ConversationalTalkBack.swift                       │
│  - startMCPMonitoring() polls every 0.5s                    │
│  - checkForMCPMessages() reads JSON file                    │
│  - generateRoastResponse() picks roast level                │
│  - askOpenAIForRoast() gets savage AI response              │
│  - speakWithElevenLabs() delivers roast via Ivanna voice    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔥 Roast Levels

### Level 1: Sassy Success (0 errors) 💅
**Trigger**: Code runs perfectly
**Example**: *"Oh wow, it ACTUALLY worked? Color me shocked, darling! Don't get cocky now. 💅✨"*

### Level 2: Minor Sass (1 error) 😏
**Trigger**: Exactly 1 error detected
**Example**: *"ONE error? Cute. At least you're almost there, sweetheart. 😏"*

### Level 3: FULL ROAST MODE (2+ errors) 🔥💀
**Trigger**: 2 or more errors detected
**Example**: *"Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"*

---

## 📂 Files

- **`cursor_code_monitor.py`** — Runs commands, counts errors, sends roast triggers to TalkBack
- **`cursor_mcp_server.py`** — Full MCP server for Cursor integration (requires `mcp` package)
- **`broken_code.py`** — Test script with intentional errors (for testing roasts)
- **`test_mcp_connection.py`** — Verifies the MCP message file pipeline works

---

## 🚀 Quick Start

### 1. Start TalkBack
```bash
./ConversationalTalkBack
```

You'll see in the startup output:
```
🔥 MCP MONITORING ACTIVE! (Watching Cursor terminal for errors)
🔥 WATCHING YOUR CODE! (I'll roast you if 2+ errors)
```

### 2. Test with Success (0 errors)
```bash
python3 cursor_code_monitor.py run 'echo Success!'
```

### 3. Test with 1 Error
```bash
python3 cursor_code_monitor.py run 'python3 -c "print(undefined_var)"'
```

### 4. Test with Multiple Errors (FULL ROAST)
```bash
python3 cursor_code_monitor.py run 'python3 broken_code.py'
```

---

## 🎯 Integration with Your Workflow

### Method 1: Wrap Your Commands
Instead of running:
```bash
python my_script.py
```

Run:
```bash
python3 cursor_code_monitor.py run 'python my_script.py'
```

### Method 2: Create Aliases (Recommended)
Add to your `~/.zshrc` or `~/.bashrc`:

```bash
alias pyroast='python3 cursor_code_monitor.py run "python3'
alias swiftroast='python3 cursor_code_monitor.py run "swift'
alias noderoast='python3 cursor_code_monitor.py run "node'
```

Then reload your shell:
```bash
source ~/.zshrc
```

Now you can just:
```bash
pyroast my_script.py"
swiftroast my_code.swift"
noderoast app.js"
```

### Method 3: Cursor IDE Terminal Integration
In Cursor, you can create custom tasks in `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run with TalkBack Roasting",
      "type": "shell",
      "command": "python3",
      "args": [
        "cursor_code_monitor.py",
        "run",
        "${file}"
      ],
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
```

---

## 🔧 Technical Details

### Error Detection Patterns
The monitor looks for these error patterns in terminal output:
- `error:`, `Error:`, `ERROR:`
- `Traceback` (Python)
- `SyntaxError`, `TypeError`, `ValueError`, `NameError`, etc.
- `AttributeError`, `ImportError`, `ModuleNotFoundError`

### Polling Mechanism
- **Frequency**: TalkBack checks `/tmp/talkback_message.json` every **0.5 seconds**
- **Debouncing**: Only processes new messages (checks timestamp)
- **Non-blocking**: Runs on a separate timer, doesn't interfere with other features

---

## 🐛 Troubleshooting

### TalkBack not roasting?
1. Check if TalkBack is running: `ps aux | grep ConversationalTalkBack`
2. Verify the JSON file is being created: `cat /tmp/talkback_message.json`
3. Check TalkBack terminal output for "📬 New MCP message" logs

### Want different error thresholds?
Edit `cursor_code_monitor.py` — adjust the `count_errors_in_output` method or the threshold logic in `send_to_talkback`.

---

## 🎉 Examples in Action

```bash
# Test 1: Python with syntax error
$ python3 cursor_code_monitor.py run 'python3 -c "print(hello"'
📊 Command finished: 1 errors, success=False
✅ Sent to TalkBack: minor_sass (errors: 1)

# Test 2: Successful execution
$ python3 cursor_code_monitor.py run 'echo "Hello World"'
📊 Command finished: 0 errors, success=True
✅ Sent to TalkBack: sassy_success (errors: 0)

# Test 3: Multiple errors (FULL ROAST)
$ python3 cursor_code_monitor.py run 'python3 broken_code.py'
📊 Command finished: 5 errors, success=False
✅ Sent to TalkBack: roast (errors: 5)
```

---

## 🙏 Credits

- **MCP Concept**: Inspired by Model Context Protocol for AI integrations
- **Roasting AI**: Powered by OpenAI GPT-4o
- **Voice**: ElevenLabs Ivanna voice

---

**Have fun coding, and may your errors be few and your roasts be savage! 🔥😎**
