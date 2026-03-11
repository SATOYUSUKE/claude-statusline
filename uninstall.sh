#!/usr/bin/env bash
set -euo pipefail

TARGET="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.local.json"

echo "Uninstalling Claude Code Statusline..."

# Remove script
if [ -f "$TARGET" ]; then
  rm "$TARGET"
  echo "Removed $TARGET"
else
  echo "$TARGET not found, skipping."
fi

# Remove statusLine from settings.local.json
if [ -f "$SETTINGS" ] && jq -e '.statusLine' "$SETTINGS" > /dev/null 2>&1; then
  tmp=$(mktemp)
  jq 'del(.statusLine)' "$SETTINGS" > "$tmp"
  mv "$tmp" "$SETTINGS"
  echo "Removed statusLine from $SETTINGS"
else
  echo "statusLine not found in $SETTINGS, skipping."
fi

echo ""
echo "Done! Restart Claude Code to apply."
