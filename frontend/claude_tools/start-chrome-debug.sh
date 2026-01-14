#!/bin/bash
#
# Launch Chrome with remote debugging enabled for Chrome DevTools MCP
#
# Usage: ./start-chrome-debug.sh
#

echo "🌐 Starting Chrome with remote debugging on port 9222..."

# Kill any existing Chrome debug instances
pkill -f "remote-debugging-port=9222" 2>/dev/null || true

# Create a dedicated debug profile directory
DEBUG_PROFILE="/tmp/chrome-claude-debug"
mkdir -p "$DEBUG_PROFILE"

# Launch Chrome
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --remote-debugging-port=9222 \
    --user-data-dir="$DEBUG_PROFILE" \
    --no-first-run \
    --no-default-browser-check \
    http://localhost:9000 &
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  google-chrome \
    --remote-debugging-port=9222 \
    --user-data-dir="$DEBUG_PROFILE" \
    --no-first-run \
    --no-default-browser-check \
    http://localhost:9000 &
fi

echo "✅ Chrome started with debugging enabled"
echo ""
echo "📋 Chrome DevTools MCP can now connect via port 9222"
echo "   Use: 'use chrome-devtools to check for console errors'"
echo ""
echo "⚠️  Note: This uses a separate profile at $DEBUG_PROFILE"
echo "   Your regular Chrome profile/logins are not affected"
