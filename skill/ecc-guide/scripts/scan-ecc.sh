#!/usr/bin/env bash
# scan-ecc.sh — 扫描 ECC 仓库并输出 JSON inventory
# Usage: scan-ecc.sh ECC_ROOT
# Output: JSON to stdout
# Requires: jq

set -euo pipefail

ECC_ROOT="$1"

if [[ ! -d "$ECC_ROOT" ]]; then
  echo "ERROR: ECC_ROOT not found: $ECC_ROOT" >&2
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required but not installed" >&2
  exit 1
fi

# 从 YAML frontmatter 提取字段值
# Usage: extract_field FILE FIELD
extract_field() {
  local file="$1" field="$2"
  awk -v f="$field" '
    BEGIN { fm=0 }
    /^---$/ { fm++; next }
    fm==1 {
      n = length(f) + 2
      if (substr($0, 1, n) == f ": ") {
        val = substr($0, n+1)
        # 去除首尾引号
        gsub(/^"/, "", val); gsub(/"$/, "", val)
        gsub(/^'"'"'/, "", val); gsub(/'"'"'$/, "", val)
        print val; exit
      }
    }
    fm>=2 { exit }
  ' "$file"
}

# 读取正文第一个有意义的行（frontmatter 之后，非标题非空行）
extract_body_first_line() {
  local file="$1"
  awk '
    BEGIN { fm=0; done=0 }
    /^---$/ { fm++; next }
    fm<2 { next }
    /^#/ { next }
    /^[[:space:]]*$/ { next }
    { print substr($0, 1, 120); exit }
  ' "$file"
}

# 扫描 agents/
scan_agents() {
  local arr=()
  while IFS= read -r f; do
    local name desc
    name=$(extract_field "$f" "name")
    desc=$(extract_field "$f" "description")
    [[ -z "$name" ]] && name=$(basename "$f" .md)
    arr+=("$(jq -n --arg n "$name" --arg d "$desc" --arg p "$f" \
      '{name:$n, description:$d, path:$p}')")
  done < <(find "$ECC_ROOT/agents" -name "*.md" | sort)
  printf '%s\n' "${arr[@]}" | jq -s '.'
}

# 扫描 commands/
scan_commands() {
  local arr=()
  while IFS= read -r f; do
    local name desc
    name=$(basename "$f" .md)
    desc=$(extract_field "$f" "description")
    # fallback: 读正文第一有效行
    [[ -z "$desc" ]] && desc=$(extract_body_first_line "$f")
    arr+=("$(jq -n --arg n "$name" --arg d "$desc" --arg p "$f" \
      '{name:$n, description:$d, path:$p}')")
  done < <(find "$ECC_ROOT/commands" -name "*.md" | sort)
  printf '%s\n' "${arr[@]}" | jq -s '.'
}

# 扫描 skills/（只含 SKILL.md 的目录）
scan_skills() {
  local arr=()
  while IFS= read -r dir; do
    local skill_md="$dir/SKILL.md"
    [[ -f "$skill_md" ]] || continue
    local name desc origin
    name=$(basename "$dir")
    desc=$(extract_field "$skill_md" "description")
    origin=$(extract_field "$skill_md" "origin")
    arr+=("$(jq -n --arg n "$name" --arg d "$desc" --arg o "$origin" --arg p "$skill_md" \
      '{name:$n, description:$d, origin:$o, path:$p}')")
  done < <(find "$ECC_ROOT/skills" -maxdepth 1 -mindepth 1 -type d | sort)
  printf '%s\n' "${arr[@]}" | jq -s '.'
}

# 扫描 rules/
scan_rules() {
  local obj="{}"
  while IFS= read -r lang_dir; do
    local lang files
    lang=$(basename "$lang_dir")
    files=$(find "$lang_dir" -name "*.md" -not -name "README.md" \
            -exec basename {} .md \; | sort | jq -R . | jq -s .)
    obj=$(echo "$obj" | jq --arg lang "$lang" --argjson files "$files" \
      '. + {($lang): $files}')
  done < <(find "$ECC_ROOT/rules" -maxdepth 1 -mindepth 1 -type d | sort)
  echo "$obj"
}

VERSION=$(cat "$ECC_ROOT/VERSION" 2>/dev/null || echo "unknown")
SCANNED_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "Scanning agents..." >&2
agents=$(scan_agents)
echo "Scanning commands..." >&2
commands=$(scan_commands)
echo "Scanning skills..." >&2
skills=$(scan_skills)
echo "Scanning rules..." >&2
rules=$(scan_rules)

jq -n \
  --arg version "$VERSION" \
  --arg scanned_at "$SCANNED_AT" \
  --argjson agents "$agents" \
  --argjson commands "$commands" \
  --argjson skills "$skills" \
  --argjson rules "$rules" \
  '{
    version: $version,
    scanned_at: $scanned_at,
    agents: $agents,
    commands: $commands,
    skills: $skills,
    rules: $rules,
    counts: {
      agents: ($agents | length),
      commands: ($commands | length),
      skills: ($skills | length),
      rules: ($rules | to_entries | map(.value | length) | add)
    }
  }'
