#!/usr/bin/env bash
set -euo pipefail

REPO="https://raw.githubusercontent.com/MiLk/agentic-super-search/main"
INSTALL_PATH="$HOME/.ass-tools.sh"
SOURCE_LINE="source \"$HOME/.ass-tools.sh\""

echo "🍑 Installing ASS Tools..."

curl -fsSL "$REPO/ass-tools.sh" -o "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [[ -f "$rc" ]] && ! grep -qF "$SOURCE_LINE" "$rc"; then
    echo "" >> "$rc"
    echo "# ASS Tools — Agentic Super Search" >> "$rc"
    echo "$SOURCE_LINE" >> "$rc"
    echo "  ✅ Added to $rc"
  fi
done

echo ""
echo "✅ ASS Tools installed! Reload your shell or run:"
echo "   source ~/.ass-tools.sh"
echo ""
echo "Available commands: dumbass, badass, hardass, kickass, smartass"
