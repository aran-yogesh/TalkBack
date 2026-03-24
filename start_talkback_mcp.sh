#!/bin/bash

# TalkBack MCP Starter Script

echo "🤖 Starting TalkBack with Cursor IDE Integration..."
echo ""

# Check if compiled
if [ ! -f "ConversationalTalkBack" ]; then
    echo "📦 Compiling ConversationalTalkBack..."
    swiftc -o ConversationalTalkBack config.swift ConversationalTalkBack.swift \
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

python3 -c "import watchdog" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️  'watchdog' not installed. Installing..."
    pip3 install watchdog
fi

echo ""
echo "✅ All dependencies ready!"
echo ""
echo "🚀 Starting TalkBack Avatar..."
echo ""

# Start TalkBack in background
./ConversationalTalkBack &
TALKBACK_PID=$!

echo "✅ TalkBack running (PID: $TALKBACK_PID)"
echo ""
echo "📋 Quick Guide:"
echo "   1. Run code with: python3 cursor_code_monitor.py run \"YOUR_COMMAND\""
echo "   2. Test connection with: python3 test_mcp_connection.py"
echo "   3. Stop TalkBack: kill $TALKBACK_PID"
echo ""
echo "🎤 TalkBack is watching your code... Ready to roast! 🔥"
echo ""
echo "Press Ctrl+C to stop monitoring..."

# Keep script running
wait "$TALKBACK_PID"

