# MCP Integration Guide 🔥

## Overview

TalkBack now includes **MCP (Model Context Protocol) Code Monitoring** that watches your terminal for code execution results and automatically roasts you when your code fails! 

This feature seamlessly integrates with your Cursor IDE workflow without disturbing any existing functionality.

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
│          cursor_code_monitor.py (Monitor Script)              │
│  - Captures terminal output                                  │
│  - Counts errors (Traceback, SyntaxError, etc.)              │
│  - Determines roast type (roast/minor_sass/sassy_success)    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│          /tmp/talkback_message.yaml (IPC File)               │
│  prompt: "ROAST ME! 5 errors..."                             │
│  type: "roast"                                               │
│  timestamp: 1234567890.123                                   │
│  error_count: 5                                              │
│                                                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           ConversationalTalkBack.swift                       │
│  - startMCPMonitoring() polls every 0.5s                     │
│  - checkForMCPMessages() reads YAML file                     │
│  - generateRoastResponse() picks roast level                 │
│  - askOpenAIForRoast() gets savage AI response               │
│  - speakWithElevenLabs() delivers roast via Ivanna voice     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔥 Roast Levels

### Level 1: Sassy Success (0 errors) 💅
**Trigger**: Code runs perfectly  
**System Prompt**: Backhanded compliment energy  
**Example Response**: *"Oh wow, it ACTUALLY worked? Color me shocked, darling! Don't get cocky now. 💅✨"*

### Level 2: Minor Sass (1 error) 😏
**Trigger**: Exactly 1 error detected  
**System Prompt**: Light sarcasm, not too harsh  
**Example Response**: *"ONE error? Cute. At least you're almost there, sweetheart. 😏"*

### Level 3: FULL ROAST MODE (2+ errors) 🔥💀
**Trigger**: 2 or more errors detected  
**System Prompt**: SAVAGE code reviewer with NO MERCY  
**Example Response**: *"Oh HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"*

---

## 📂 Key Files

| File | Purpose |
|------|---------|
| `ConversationalTalkBack.swift` | Main app — includes MCP polling, roast generation, and TTS |
| `cursor_code_monitor.py` | Standalone code monitor (requires `watchdog`) — wraps commands and writes roast triggers |
| `cursor_mcp_server.py` | MCP server for Cursor IDE integration (requires `mcp` package, stdio transport) |
| `broken_code.py` | Intentionally broken script for testing roast triggers |
| `test_mcp_connection.py` | Quick test to verify `/tmp/talkback_message.yaml` IPC works |

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

TalkBack will respond with a sassy compliment! 💅

### 3. Test with 1 Error
```bash
python3 cursor_code_monitor.py run 'python3 -c "print(undefined_var)"'
```

TalkBack will give you light sass! 😏

### 4. Test with Multiple Errors (FULL ROAST)
```bash
python3 cursor_code_monitor.py run 'python3 broken_code.py'
```

TalkBack will ROAST YOU HARD! 🔥💀

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
# TalkBack roasting aliases
pyroast()  { python3 cursor_code_monitor.py run "python3 $*"; }
swiftroast() { python3 cursor_code_monitor.py run "swift $*"; }
noderoast()  { python3 cursor_code_monitor.py run "node $*"; }
```

Then reload your shell:
```bash
source ~/.zshrc
```

Now you can just:
```bash
pyroast my_script.py
swiftroast my_code.swift
noderoast app.js
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
      },
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}
```

---

## 🔧 Technical Details

### Error Detection Patterns
The MCP monitor looks for these error patterns in terminal output:
- `error:`, `Error:`, `ERROR:`
- `compilation failed`, `build failed`, `test failed`
- `exception`, `Exception`, `Traceback`
- `SyntaxError`, `TypeError`, `ValueError`
- `AttributeError`, `ImportError`, `ModuleNotFoundError`

### Polling Mechanism
- **Frequency**: TalkBack checks `/tmp/talkback_message.yaml` every **0.5 seconds**
- **Debouncing**: Only processes new messages (checks timestamp)
- **Non-blocking**: Runs on a separate timer, doesn't interfere with other features

### OpenAI Prompts
Each roast level has a custom system prompt:

**Roast (2+ errors)**:
```
You are TalkBack, a SAVAGE code reviewer with NO MERCY! 
The user's code just FAILED with 2+ errors.
Your job: ROAST THEM HARD but be funny about it. 
Use dramatic language, emojis, and sass.
Make them laugh while feeling the burn.
Keep it under 40 words but make it HURT (in a fun way).
```

**Minor Sass (1 error)**:
```
You are TalkBack, a sassy code reviewer. 
The user got 1 error. 
Give them a little attitude but not too harsh.
Be witty and sarcastic. Keep it under 30 words.
```

**Sassy Success (0 errors)**:
```
You are TalkBack, a sassy AI. 
The user's code ran successfully!
Say "okay you made it this time" but with MAJOR attitude and sass.
Backhanded compliment energy.
Keep it under 30 words. Be dramatic.
```

---

## 💡 Tips & Best Practices

1. **Always Have TalkBack Running**: Start it at the beginning of your coding session
2. **Use for Quick Tests**: Perfect for rapid iteration and debugging
3. **Don't Take It Personally**: The roasts are meant to be funny and motivating!
4. **Celebrate Successes**: Even the sassy success responses are encouraging
5. **Share with Friends**: Record TalkBack roasting you and share the laughs

---

## 🐛 Troubleshooting

### TalkBack not roasting?
1. Check if TalkBack is running: `ps aux | grep ConversationalTalkBack`
2. Verify the YAML file is being created: `cat /tmp/talkback_message.yaml`
3. Check TalkBack terminal output for "📬 New MCP message" logs

### Roasts are too harsh/mild?
- Edit the `generateRoastResponse` function in `ConversationalTalkBack.swift`
- Adjust the system prompts to your liking
- Recompile: `swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift -framework Cocoa -framework Foundation -framework AVFoundation -target arm64-apple-macosx13.0`

### Want different error thresholds?
- Edit `cursor_code_monitor.py`
- Adjust the `send_to_talkback` method to change when each roast type triggers

---

## 🎉 Examples in Action

```bash
# Test 1: Python with syntax error
$ python3 cursor_code_monitor.py run 'python3 -c "print(hello"'
📊 Command finished: 1 errors, success=False
✅ Sent to TalkBack: minor_sass (errors: 1)
🎤 TalkBack should roast you in 3... 2... 1... 🔥

TalkBack (Ivanna): "Aww, ONE error? How precious! You're thisclose, sweetie. 😏"

# Test 2: Successful execution
$ python3 cursor_code_monitor.py run 'echo "Hello World"'
📊 Command finished: 0 errors, success=True
✅ Sent to TalkBack: sassy_success (errors: 0)
🎤 TalkBack should roast you in 3... 2... 1... 🔥

TalkBack (Ivanna): "Oh WOW, it actually worked?! Mark the calendar, folks! Don't let it go to your head. 💅✨"

# Test 3: Multiple errors (FULL ROAST)
$ python3 cursor_code_monitor.py run 'python3 broken_code.py'
📊 Command finished: 5 errors, success=False
✅ Sent to TalkBack: roast (errors: 5)
🎤 TalkBack should roast you in 3... 2... 1... 🔥

TalkBack (Ivanna): "Oh HONEY NO. FIVE errors?! Did you just smash your keyboard and call it code? This is a HOT MESS EXPRESS! 🔥💀🚂"
```

---

## 🚧 Future Enhancements

Potential improvements for the MCP integration:

1. **Real-time linter integration**: Watch Cursor linter in real-time
2. **Git commit hooks**: Roast on failed pre-commit checks
3. **CI/CD integration**: Roast when builds fail
4. **Custom roast templates**: User-defined roast styles
5. **Roast history**: Keep track of all roasts for fun stats
6. **Multiplayer mode**: Compete with friends for least roasts

---

## 📝 License

Same as TalkBack main project - MIT License

---

## 🙏 Credits

- **MCP Concept**: Inspired by Model Context Protocol for AI integrations
- **Roasting AI**: Powered by OpenAI GPT-4o
- **Voice**: ElevenLabs Ivanna voice
- **Attitude**: 100% TalkBack original sass 💅

---

**Have fun coding, and may your errors be few and your roasts be savage! 🔥😎**


