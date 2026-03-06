# TalkBack + Cursor MCP Integration 🤖🔥

## Overview

TalkBack integrates with Cursor IDE via MCP (Model Context Protocol) to monitor your code execution and roast you when you mess up!

### How It Works:

```
Your Code → Cursor IDE → MCP Monitor → TalkBack Avatar → Ivanna's Voice Roast
                              ↓
                    (counts errors in output)
                              ↓
                    2+ errors = ROAST MODE 🔥
                    1 error   = Minor sass 😏
                    0 errors  = Sassy success 💅
```

## Quick Start

### 1. Configure API Keys

```bash
cp config.swift.template config.swift
```

Edit `config.swift` with your OpenAI and ElevenLabs keys. See [API_KEY_SETUP.md](API_KEY_SETUP.md) for details.

### 2. Compile TalkBack

```bash
swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

### 3. Run TalkBack Avatar

```bash
./ConversationalTalkBack
```

The avatar will appear on your screen, watching your code! 👀

### 4. Run Code with Monitoring

```bash
# Python example
python3 cursor_code_monitor.py run 'python your_script.py'

# Swift example
python3 cursor_code_monitor.py run 'swift your_file.swift'

# npm/node example
python3 cursor_code_monitor.py run 'npm test'

# Any command
python3 cursor_code_monitor.py run 'YOUR_COMMAND_HERE'
```

## Integration with Cursor IDE

### Option 1: Manual Integration (Easiest)

1. Open Cursor
2. Run your code in the terminal
3. In another terminal, run:
   ```bash
   python3 cursor_code_monitor.py run 'YOUR_COMMAND'
   ```

### Option 2: MCP Server Integration (Advanced)

1. Add MCP server to Cursor settings:

   Copy the contents of `mcp_config.json` to your Cursor MCP settings:

   **Mac**: `~/Library/Application Support/Cursor/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json`

2. Restart Cursor

3. The MCP server will now monitor your code execution automatically!

## Roast Examples

### 2+ Errors (ROAST MODE 🔥):
> "OH HONEY, what is this hot mess? Did you code this with your eyes closed? 🔥💀"

### 1 Error (Minor Sass 😏):
> "ONE error? Cute. At least you're almost there, sweetheart. 😏"

### Success (Sassy Success 💅):
> "Oh wow, it ACTUALLY worked? Color me shocked, darling! Don't get cocky now. 💅✨"
