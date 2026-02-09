#!/bin/bash

# TalkBack MCP Starter Script

echo "⚠️  DEPRECATION WARNING: This script is deprecated."
echo "   The watchdog-based cursor_code_monitor.py is no longer used."
echo "   Use cursor_mcp_server.py directly via the MCP protocol instead."
echo ""
echo "🤖 Starting TalkBack with Cursor IDE Integration..."
echo ""

# Check if compiled
if [ ! -f "MCPTalkBack" ]; then
    echo "📦 Compiling MCPTalkBack..."
    swiftc -o MCPTalkBack MCPTalkBack.swift \
      -framework Cocoa -framework Foundation -framework AVFoundation \
      -target arm64-apple-macosx13.0
    
    if [ $? -ne 0 ]; then
        echo "❌ Compilation failed!"
        exit 1
    fi
    echo "✅ Compilation successful!"
fi

# Check Python dependencies
echo "🔍 Checking Python dependencies..."
python3 -c "import mcp" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️  'mcp' not installed. Installing..."
    pip3 install mcp
fi

echo "⚠️  Skipping deprecated watchdog dependency (no longer required)."

echo ""
echo "✅ All dependencies ready!"
echo ""
echo "🚀 Starting TalkBack Avatar..."
echo ""

# Start TalkBack in background
./MCPTalkBack &
TALKBACK_PID=$!

echo "✅ TalkBack running (PID: $TALKBACK_PID)"
echo ""
echo "📋 Quick Guide:"
echo "   1. (DEPRECATED) Run code with: python3 cursor_code_monitor.py run \"YOUR_COMMAND\""
echo "      ↳ Use cursor_mcp_server.py via MCP protocol instead."
echo "   2. Test roasts with: python3 test_roast.py [1|2|3]"
echo "   3. Stop TalkBack: kill $TALKBACK_PID"
echo ""
echo "🎤 TalkBack is watching your code... Ready to roast! 🔥"
echo ""
echo "Press Ctrl+C to stop monitoring..."

# Keep script running
wait $TALKBACK_PID

