#!/bin/bash
set -euo pipefail

# TalkBack MCP Starter Script

cleanup() {
    if [ -n "${TALKBACK_PID:-}" ] && kill -0 "$TALKBACK_PID" 2>/dev/null; then
        echo ""
        echo "🛑 Stopping TalkBack (PID: $TALKBACK_PID)..."
        kill "$TALKBACK_PID" 2>/dev/null || true
    fi
}
trap cleanup EXIT INT TERM

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
if ! python3 -c "import mcp" 2>/dev/null; then
    echo "⚠️  'mcp' not installed. Installing..."
    pip3 install mcp || { echo "❌ Failed to install mcp"; exit 1; }
fi

if ! python3 -c "import watchdog" 2>/dev/null; then
    echo "⚠️  'watchdog' not installed. Installing..."
    pip3 install watchdog || { echo "❌ Failed to install watchdog"; exit 1; }
fi

echo ""
echo "✅ All dependencies ready!"
echo ""
echo "🚀 Starting TalkBack Avatar..."
echo ""

# Start TalkBack in background
./MCPTalkBack &
TALKBACK_PID=$!

sleep 0.5
if ! kill -0 "$TALKBACK_PID" 2>/dev/null; then
    echo "❌ TalkBack failed to start!"
    exit 1
fi

echo "✅ TalkBack running (PID: $TALKBACK_PID)"
echo ""
echo "📋 Quick Guide:"
echo "   1. Run code with: python3 cursor_code_monitor.py run \"YOUR_COMMAND\""
echo "   2. Test roasts with: python3 test_roast.py [1|2|3]"
echo "   3. Stop TalkBack: kill $TALKBACK_PID"
echo ""
echo "🎤 TalkBack is watching your code... Ready to roast! 🔥"
echo ""
echo "Press Ctrl+C to stop monitoring..."

# Keep script running
wait $TALKBACK_PID

