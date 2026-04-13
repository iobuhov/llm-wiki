#!/usr/bin/env bash
# claude-obsidian vault setup script
# Run this ONCE before opening Obsidian for the first time.
# Usage: bash bin/setup-vault.sh [optional: /path/to/vault]
# Default: uses the directory where this script lives (the vault root)

set -euo pipefail

VAULT="${1:-$(pwd)}"
OBSIDIAN="$VAULT/.obsidian"

echo "Setting up claude-obsidian vault at: $VAULT"

mkdir -p "$VAULT/.raw"
mkdir -p "$VAULT/wiki/concepts" "$VAULT/wiki/entities" "$VAULT/wiki/sources" "$VAULT/wiki/meta"

# ── 5. Download Excalidraw main.js (8MB, not in git) ─────────────────────────
EXCALIDRAW="$OBSIDIAN/plugins/obsidian-excalidraw-plugin"
if [ -f "$EXCALIDRAW/manifest.json" ] && [ ! -f "$EXCALIDRAW/main.js" ]; then
  echo "Downloading Excalidraw main.js (~8MB)..."
  curl -sS -L \
    "https://github.com/zsviczian/obsidian-excalidraw-plugin/releases/latest/download/main.js" \
    -o "$EXCALIDRAW/main.js"
  echo "✓ Excalidraw main.js downloaded"
elif [ -f "$EXCALIDRAW/main.js" ]; then
  echo "✓ Excalidraw main.js already present"
fi

if ! claude plugin marketplace list 2>/dev/null | grep -q "iobuhov_llm-wiki"; then
  claude plugin marketplace add iobuhov/llm-wiki
fi

claude plugin install -s project llm-wiki@iobuhov_llm-wiki


echo ""
echo "✓ Setup complete."
