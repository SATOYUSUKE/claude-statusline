#!/usr/bin/env bash
set -euo pipefail

SCRIPT_URL="https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/statusline.sh"
TARGET="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.local.json"

echo "Installing Claude Code Statusline..."

# Download script
curl -fsSL "$SCRIPT_URL" -o "$TARGET"
chmod +x "$TARGET"

# Add statusLine config to settings.local.json
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

# Check if statusLine already set
if jq -e '.statusLine' "$SETTINGS" > /dev/null 2>&1; then
  echo "statusLine is already configured in $SETTINGS. Skipping."
else
  tmp=$(mktemp)
  jq '. + {"statusLine": {"type": "command", "command": "bash ~/.claude/statusline.sh"}}' "$SETTINGS" > "$tmp"
  mv "$tmp" "$SETTINGS"
  echo "Added statusLine config to $SETTINGS"
fi

echo ""
echo "Done! Restart Claude Code to apply."
echo ""
echo "Display:"
echo "  Line 1: 📁 folder | 🤖 model | \$cost | ✏️ +added/-removed | 🔀 branch"
echo "  Line 2: 🧠 ctx% | IN:xxxK  OUT:xxxK  cache:xx%"
echo "  Line 3: ⏱ 5h usage bar + reset time  (subscription only)"
echo "  Line 4: 📅 7d usage bar + reset time  (subscription only)"
