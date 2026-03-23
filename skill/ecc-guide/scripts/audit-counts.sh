#!/usr/bin/env bash
# audit-counts.sh — 快速确定性数量统计
# Usage: audit-counts.sh ECC_ROOT
# Output: KEY=VALUE 格式，每行一个

set -euo pipefail

ECC_ROOT="$1"

if [[ ! -d "$ECC_ROOT" ]]; then
  echo "ERROR: ECC_ROOT not found: $ECC_ROOT" >&2
  exit 1
fi

agents=$(find "$ECC_ROOT/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
commands=$(find "$ECC_ROOT/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
# 只统计含 SKILL.md 的目录
skills=$(find "$ECC_ROOT/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | while read -r d; do
  [[ -f "$d/SKILL.md" ]] && echo "$d"
done | wc -l | tr -d ' ')
rules=$(find "$ECC_ROOT/rules" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')

echo "actual_agents=$agents"
echo "actual_commands=$commands"
echo "actual_skills=$skills"
echo "actual_rules=$rules"
