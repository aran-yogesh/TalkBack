#!/bin/bash

echo "Starting TalkBack MCP Integration Setup"
echo "=========================================="

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Virtual environment not found. Please run: python -m venv .venv"
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# Check if MCP is installed
echo "Checking MCP installation..."
python -c "import mcp; print('MCP package is installed!')" || {
    echo "MCP package not found. Installing..."
    pip install mcp
}

# Test MCP server
echo "Testing MCP server..."
python test_mcp_connection.py

# Check if message file was created
if [ -f "/tmp/talkback_message.json" ]; then
    echo "MCP server test successful!"
    echo "Message file created at: /tmp/talkback_message.json"
else
    echo "MCP server test failed!"
    exit 1
fi

echo ""
echo "Next Steps:"
echo "1. Quit Cursor completely"
echo "2. Restart Cursor (it will auto-connect to MCP server)"
echo "3. Run: swift ConversationalTalkBack.swift"
echo "4. In Cursor's terminal, run some commands to test!"
echo ""
echo "Your coding assistant is ready to roast you!"
