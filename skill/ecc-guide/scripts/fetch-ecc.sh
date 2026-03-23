#!/usr/bin/env bash
# fetch-ecc.sh — 获取或更新 ECC 仓库
# Usage: fetch-ecc.sh [TARGET_DIR]
# Output: stdout 输出实际路径，失败时 exit 1

set -euo pipefail

TARGET="${1:-/tmp/ecc-source}"
REPO_URL="https://github.com/affaan-m/everything-claude-code.git"

if [[ -d "$TARGET/.git" ]]; then
  echo "Updating existing clone at $TARGET..." >&2
  git -C "$TARGET" pull --quiet --ff-only 2>&1 || {
    echo "WARNING: git pull failed, using existing local copy" >&2
  }
else
  echo "Cloning ECC repository (depth=1)..." >&2
  mkdir -p "$(dirname "$TARGET")"
  git clone --depth 1 --quiet "$REPO_URL" "$TARGET" || {
    echo "ERROR: Failed to clone ECC repository from $REPO_URL" >&2
    exit 1
  }
fi

echo "$TARGET"
