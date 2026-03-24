# TalkBack + Cursor MCP Integration 🤖🔥

## Overview

TalkBack now integrates with Cursor IDE via MCP (Model Context Protocol) to monitor your code execution and roast you when you mess up!

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

### 1. Install Python Dependencies

```bash
pip3 install mcp watchdog
```

### 2. Add Your API Keys

Copy the template and add your keys:
```bash
cp config.swift.template config.swift
```
Edit `config.swift` with your actual API keys.

### 3. Compile TalkBack with MCP Support

```bash
swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
  -framework Cocoa -framework Foundation -framework AVFoundation \
  -target arm64-apple-macosx13.0
```

### 4. Run TalkBack Avatar

```bash
./ConversationalTalkBack &
```

The avatar will appear on your screen, watching your code! 👀

### 5. Run Code with Monitoring

Now when you run code in Cursor, use the monitor script:

```bash
# Python example
python3 cursor_code_monitor.py run "python your_script.py"

# Swift example
python3 cursor_code_monitor.py run "swift your_file.swift"

# npm/node example
python3 cursor_code_monitor.py run "npm test"

# Any command
python3 cursor_code_monitor.py run "YOUR_COMMAND_HERE"
```

## Integration with Cursor IDE

### Option 1: Manual Integration (Easiest)

1. Open Cursor
2. Run your code in the terminal
3. In another terminal, run:
   ```bash
   python3 cursor_code_monitor.py run "YOUR_COMMAND"
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

## How to Use

1. **Start TalkBack**: Run `./ConversationalTalkBack`
2. **Code in Cursor**: Write your code as usual
3. **Run with Monitor**: Use `cursor_code_monitor.py run "your_command"`
4. **Get Roasted**: TalkBack watches the output and roasts you accordingly! 🔥

## Features

✅ Real-time code execution monitoring  
✅ Error counting and analysis  
✅ Smart roasting based on error count  
✅ ElevenLabs voice (Ivanna) for maximum sass  
✅ OpenAI GPT-4o-mini for witty roasts  
✅ Works with any programming language  
✅ Draggable avatar (drag to trash to quit)  
✅ Always on top - can't escape the judgment! 😈  

## Troubleshooting

### TalkBack not roasting?
- Check that `ConversationalTalkBack` is running (`ps aux | grep ConversationalTalkBack`)
- Check that `/tmp/talkback_message.yaml` exists and is being written
- Check terminal output for errors

### No voice output?
- Verify ElevenLabs API key is correct
- Check system volume
- Look for `🎤 ElevenLabs TTS HTTP Status: 200` in terminal

### Errors not detected?
- Check the output of your command manually
- The monitor looks for common error patterns (see `cursor_code_monitor.py`)
- You can customize error detection in the Python script

## Customization

### Change Roast Severity

Edit `ConversationalTalkBack.swift`, find the `generateRoastResponse` function and modify the prompts:

```swift
case "roast":
    systemPrompt = """
    Your custom ROAST prompt here! Make it BRUTAL! 🔥
    """
```

### Add More Error Patterns

Edit `cursor_code_monitor.py`, find `count_errors_in_output` and add patterns:

```python
error_patterns = [
    r'your_custom_error_pattern',
    # ... add more
]
```

## What's Next?

Future features:
- [ ] Automatic Cursor terminal monitoring (no manual script needed)
- [ ] Code suggestion roasts
- [ ] Productivity tracking
- [ ] Custom roast personalities
- [ ] Integration with GitHub for commit roasts

---

**Made with 💻 and a lot of sass** by [@aran-yogesh](https://github.com/aran-yogesh)

🔥 **Now go code and get roasted!** 🔥

