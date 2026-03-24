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
│          cursor_code_monitor.py (Monitor Script)            │
│  - Captures terminal output                                 │
│  - Counts errors (Traceback, SyntaxError, etc.)             │
│  - Determines roast type (roast/minor_sass/sassy_success)   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│          /tmp/talkback_message.yaml (IPC File)              │
│  prompt: "ROAST ME! 5 errors..."                            │
│  type: roast                                                │
│  timestamp: 1234567890.123                                  │
│  error_count: 5                                             │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           ConversationalTalkBack.swift                       │
│  - startMCPMonitoring() polls every 0.5s                    │
│  - checkForMCPMessages() reads YAML file                    │
│  - generateRoastResponse() picks roast level                │
│  - askOpenAIForRoast() gets savage AI response              │
│  - speakWithElevenLabs() delivers roast via Ivanna voice    │
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

## 📂 Files Added/Modified

### New Files:
- **`cursor_code_monitor.py`**: Code monitor script
  - Runs commands and monitors output
  - Counts errors using regex patterns
  - Sends roast triggers to TalkBack

- **`cursor_mcp_server.py`**: MCP server for Cursor IDE integration (stdio transport)

- **`broken_code.py`**: Test script with intentional errors (for testing roasts)

- **`MCP_INTEGRATION.md`**: This documentation file

### Modified Files:
- **`ConversationalTalkBack.swift`**: 
  - Added MCP monitoring variables (`mcpMonitorTimer`, `lastMCPMessageTime`, `mcpMessageFile`)
  - Added `startMCPMonitoring()` function
  - Added `checkForMCPMessages()` function
  - Added `generateRoastResponse(prompt:type:)` function
  - Added `askOpenAIForRoast(prompt:systemPrompt:)` function
  - Updated startup message to mention MCP monitoring

- **`README.md`**:
  - Added MCP Code Monitor feature section
  - Added usage instructions for MCP testing
  - Added examples for all 3 roast levels

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
python3 my_script.py
```

Run:
```bash
python3 cursor_code_monitor.py run 'python3 my_script.py'
```

### Method 2: Create Aliases (Recommended)
Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# TalkBack roasting aliases (update the path to your repo location)
alias pyroast='python3 cursor_code_monitor.py run "python3 $@"'
alias swiftroast='python3 cursor_code_monitor.py run "swift $@"'
alias noderoast='python3 cursor_code_monitor.py run "node $@"'
```

Then reload your shell:
```bash
source ~/.zshrc
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
