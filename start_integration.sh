#!/bin/bash

# DEPRECATED: This integration script sets up the legacy Python-based MCP
# pipeline which uses file-based IPC via /tmp/talkback_message.json.
# The built-in Swift MCP monitoring in ConversationalTalkBack.swift is the
# recommended approach. This script will be removed in a future release.

echo "🚀 Starting TalkBack MCP Integration Setup"
echo "=========================================="
echo ""
echo "⚠️  DEPRECATION WARNING: This integration script is deprecated."
echo "   The Python MCP server and file-based IPC have been superseded"
echo "   by the built-in Swift MCP monitoring. See ConversationalTalkBack.swift."
echo ""

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "❌ Virtual environment not found. Please run: python3 -m venv .venv"
    exit 1
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source .venv/bin/activate

# Check if MCP is installed
echo "🔍 Checking MCP installation..."
python3 -c "import mcp; print('✅ MCP package is installed!')" || {
    echo "❌ MCP package not found. Installing..."
    pip install mcp
}

# Test MCP server
echo "🧪 Testing MCP server..."
python3 test_mcp_connection.py

# Check if message file was created
if [ -f "/tmp/talkback_message.json" ]; then
    echo "✅ MCP server test successful!"
    echo "📁 Message file created at: /tmp/talkback_message.json"
else
    echo "❌ MCP server test failed!"
    exit 1
fi

echo ""
echo "🎯 Next Steps:"
echo "1. Quit Cursor completely"
echo "2. Restart Cursor (it will auto-connect to MCP server)"
echo "3. Run: swift ConversationalTalkBack.swift"
echo "4. In Cursor's terminal, run some commands to test!"
echo ""
echo "🔥 Your coding assistant is ready to roast you!"
