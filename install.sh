#!/usr/bin/env bash
# ==============================================================================
# Context Engineer — Universal Agent Harness Installer
# https://github.com/skillustrate/context-engineer
# ==============================================================================

set -e

REPO_URL="https://github.com/skillustrate/context-engineer"
SKILL_NAME="context-engineering"
TEMP_DIR=""

cleanup() {
  if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

echo "====================================================="
echo " Installing Context Engineer Skill"
echo "====================================================="

# Locate source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
if [ -d "$SCRIPT_DIR/skills/$SKILL_NAME" ]; then
  SRC_DIR="$SCRIPT_DIR/skills/$SKILL_NAME"
else
  echo "-> Downloading skill from GitHub..."
  TEMP_DIR="$(mktemp -d)"
  git clone --depth 1 "$REPO_URL.git" "$TEMP_DIR/context-engineer" >/dev/null 2>&1
  SRC_DIR="$TEMP_DIR/context-engineer/skills/$SKILL_NAME"
fi

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Skill source directory not found."
  exit 1
fi

INSTALLED_ANY=false

# 1. Google Antigravity / Gemini CLI
ANTIGRAVITY_GLOBAL="$HOME/.gemini/antigravity-cli/skills"
if [ -d "$HOME/.gemini" ] || [ -d "$HOME/.gemini/antigravity-cli" ]; then
  mkdir -p "$ANTIGRAVITY_GLOBAL"
  rm -rf "$ANTIGRAVITY_GLOBAL/$SKILL_NAME"
  cp -r "$SRC_DIR" "$ANTIGRAVITY_GLOBAL/$SKILL_NAME"
  echo " [✓] Installed for Google Antigravity / Gemini CLI: $ANTIGRAVITY_GLOBAL/$SKILL_NAME"
  INSTALLED_ANY=true
fi

# 2. Claude Code
CLAUDE_GLOBAL="$HOME/.claude/skills"
if [ -d "$HOME/.claude" ]; then
  mkdir -p "$CLAUDE_GLOBAL"
  rm -rf "$CLAUDE_GLOBAL/$SKILL_NAME"
  cp -r "$SRC_DIR" "$CLAUDE_GLOBAL/$SKILL_NAME"
  echo " [✓] Installed for Claude Code: $CLAUDE_GLOBAL/$SKILL_NAME"
  INSTALLED_ANY=true
fi

# 3. Current Workspace Local Installation
if [ -d ".git" ] || [ -f "package.json" ]; then
  # Local Claude
  if [ -d ".claude" ]; then
    mkdir -p ".claude/skills"
    rm -rf ".claude/skills/$SKILL_NAME"
    cp -r "$SRC_DIR" ".claude/skills/$SKILL_NAME"
    echo " [✓] Installed in current workspace (.claude/skills/$SKILL_NAME)"
    INSTALLED_ANY=true
  fi

  # Local Antigravity / Gemini
  if [ -d ".gemini" ]; then
    mkdir -p ".gemini/skills"
    rm -rf ".gemini/skills/$SKILL_NAME"
    cp -r "$SRC_DIR" ".gemini/skills/$SKILL_NAME"
    echo " [✓] Installed in current workspace (.gemini/skills/$SKILL_NAME)"
    INSTALLED_ANY=true
  fi

  # Local Cursor
  if [ -d ".cursor" ]; then
    mkdir -p ".cursor/rules"
    if [ -f "$SCRIPT_DIR/templates/.cursorrules" ]; then
      cp "$SCRIPT_DIR/templates/.cursorrules" ".cursor/rules/context-engineering.mdc"
      echo " [✓] Added Cursor rule (.cursor/rules/context-engineering.mdc)"
      INSTALLED_ANY=true
    fi
  fi
fi

if [ "$INSTALLED_ANY" = false ]; then
  # Default fallback to Antigravity global & Claude global
  mkdir -p "$ANTIGRAVITY_GLOBAL"
  cp -r "$SRC_DIR" "$ANTIGRAVITY_GLOBAL/$SKILL_NAME"
  mkdir -p "$CLAUDE_GLOBAL"
  cp -r "$SRC_DIR" "$CLAUDE_GLOBAL/$SKILL_NAME"
  echo " [✓] Installed to standard agent skill locations:"
  echo "     - $ANTIGRAVITY_GLOBAL/$SKILL_NAME"
  echo "     - $CLAUDE_GLOBAL/$SKILL_NAME"
fi

echo "====================================================="
echo " Context Engineer is ready to use!"
echo "====================================================="
