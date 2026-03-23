---
name: ecc-guide
description: Update, generate, and audit the ECC guide docs from the latest ECC release. Run after ECC updates to sync docs and verify accuracy.
origin: Custom
tools: Read, Write, Edit, Bash, Grep, Glob, WebFetch
version: 1.0.0
---

# ECC Guide — Update, Generate & Audit

三合一 skill，用于维护 [ecc-guide](https://github.com/your-org/ecc-guide) 文档仓库。

遵循"确定性收集 + LLM 语义判断"原则：脚本精确统计事实，Claude 负责翻译、分类和质量判断。

## When to Activate

- 用户说 "update ecc-guide"、"sync ecc guide"、"ecc 出新版本了"
- 用户说 "audit ecc guide"、"verify guide"、"check the docs"
- 用户说 "full update and audit"（完整流程）
- ECC 发布新版本后需要同步文档

## 三种运行模式

| 模式 | 触发词 | 执行内容 |
|------|--------|----------|
| **Update** | update / sync / new version | 拉取 ECC → 扫描 → 重生成 docs/ → 更新 .meta.json |
| **Audit** | audit / verify / check | 5 项校验 → 输出 audit-report.md |
| **Full** | full update and audit | Update 完成后自动执行 Audit |

---

## Phase 0：解析 ECC 数据源（所有模式均需执行）

```
1. 读取 skill 同级目录的 config.json，获取 local_ecc_path 和 fallback_clone_dir
2. 若 local_ecc_path 存在且是 git 仓库（含 .git/）：
   a. 执行 git -C {local_ecc_path} pull --ff-only
   b. ECC_ROOT = local_ecc_path
3. 若本地路径不存在：
   a. 运行 scripts/fetch-ecc.sh {fallback_clone_dir}
   b. ECC_ROOT = fallback_clone_dir
4. 若 git 完全不可用（无网络）：
   - 报错并终止：
     ERROR: Cannot resolve ECC source.
     Options:
     1. Set local_ecc_path in config.json to a local clone
     2. Ensure internet connectivity for GitHub clone
5. 读取 ECC_ROOT/VERSION → ECC_VERSION（不存在则为 "unknown"）
6. 打印：Source: {ECC_ROOT} ({ECC_VERSION})
```

---

## UPDATE 模式

### Step 1：扫描 ECC 仓库

运行扫描脚本：
```bash
bash {SKILL_DIR}/scripts/scan-ecc.sh {ECC_ROOT}
```

脚本输出 JSON inventory，包含：
- `agents[]`：name, description（来自 frontmatter）
- `commands[]`：name（文件名）, description（frontmatter 或正文首行）
- `skills[]`：name（目录名）, description, origin
- `rules`：{language: [file_names]}
- `counts`：agents/commands/skills/rules 各自数量

### Step 2：生成/更新 docs/ 文件

读取 config.json 中的 `skill_categories` 和 `command_categories` 作为分类规则。

**分类算法**（技能）：
1. 对每个 skill，依序尝试每个 category 的 patterns（glob 匹配）
2. 第一个匹配的 category 即为该 skill 的归属
3. 无法匹配的 skill → 加入 `skills-business.md`（兜底），并在终端打印警告

**生成规则**：
- 每个描述翻译为中文，保持准确。翻译原则：
  - 核心动词要准确（review→审查，build→构建，fix→修复，scan→扫描）
  - 保留技术术语原文（如 OWASP Top 10、TDD、CUDA、KMP）
  - 描述长度目标：15-40 汉字
- 相似工具对（来自 config.similar_tool_pairs）的描述需在措辞上体现差异，例如：
  - `continuous-learning`：强调"从会话中提取模式并保存"
  - `continuous-learning-v2`：强调"基于本能（instinct）机制，置信度驱动"
  - `agent-eval`：强调"头对头比较不同编码代理"
  - `eval-harness`：强调"正式评估框架，衡量代理质量"

**每个 docs/ 文件的结构**：

`docs/agents.md`：
```markdown
# Agents（代理）

共 {N} 个专业化子代理，可被主 Claude 自动调用。

---

## 语言特定代理

| 代理名称 | 语言 | 作用 |
| --- | --- | --- |
...

## 通用工程代理

| 代理名称 | 作用 |
| --- | --- |
...
```

语言特定代理判断：agent name 含 `-reviewer` 或 `-build-resolver` 且名称前缀是已知语言（go, kotlin, rust, cpp, python, java, typescript, pytorch, database）。

`docs/commands.md`：
```markdown
# Commands（斜杠命令）

共 {N} 个斜杠命令，在 Claude Code 中以 `/命令名` 方式调用。

---

## {分组名}

| 命令 | 作用 |
| --- | --- |
...
```

`docs/skills-*.md`：
```markdown
# {分组中文标签}

## {子分组}（如有）

| 技能 | 作用 |
| --- | --- |
...
```

### Step 3：更新 docs/.meta.json

```json
{
  "ecc_version": "{ECC_VERSION}",
  "ecc_source": "{config.ecc_source.repo_url}",
  "generated_at": "{当前 UTC 时间}",
  "counts": {
    "agents": {N},
    "commands": {N},
    "skills": {N},
    "rules": {N}
  },
  "doc_files": ["agents.md", "commands.md", ...]
}
```

### Step 4：更新 docs/README.md

更新以下内容：
- 标题中的版本号：`基于 ... (v{ECC_VERSION})`
- 统计表格中的数字
- 目录行中 "— X个" 的数字
- Rules 分类说明（如 common 文件数有变化）

### Update 输出格式

```
ECC Guide Update
─────────────────────────────────────────
Source:  /path/to/ecc  (local)
Version: 1.9.0

Scanning...
  ✓ agents:   27
  ✓ commands: 59
  ✓ skills:   116
  ✓ rules:    60

Generating docs/
  ✓ agents.md             (27 entries, 2 groups)
  ✓ commands.md           (59 entries, 5 groups)
  ✓ skills-language.md    (26 entries)
  ✓ skills-framework.md   (13 entries)
  ✓ skills-engineering.md (18 entries)
  ✓ skills-ai-agent.md    (34 entries)
  ✓ skills-business.md    (12 entries)
  ✓ docs/.meta.json
  ✓ docs/README.md (version: 1.9.0, counts: 27/59/116/60)

Done. 9 files updated.
```

---

## AUDIT 模式

**前置条件**：若 `docs/.meta.json` 不存在，先执行 Update 模式。

读取 config.json 的 audit 配置（description_min_chars, description_max_chars, batch_size, similar_tool_pairs）。

---

### Check 1 — 数量校验（Quantity）

```bash
bash {SKILL_DIR}/scripts/audit-counts.sh {ECC_ROOT}
```

脚本输出 actual_agents、actual_commands、actual_skills、actual_rules。

对比三组数字：
1. `actual`（脚本实际统计）
2. `docs`（从 docs/README.md 统计表格提取）
3. `meta`（从 docs/.meta.json 读取）

任意不一致 → FAIL。

**输出格式**：
```
Check 1: Quantity
  agents:   actual=27, docs=27, meta=27  → PASS
  commands: actual=59, docs=59, meta=59  → PASS
  skills:   actual=116, docs=115, meta=115 → FAIL (actual +1, docs outdated)
  rules:    actual=60, docs=59, meta=59  → FAIL (actual +1)
```

---

### Check 2 — 完整性校验（Completeness）

**actual_set**：从 scan-ecc.sh 输出的 JSON 提取所有名称（agents[].name, commands[].name, skills[].name）

**documented_set**：从 docs/ 所有 md 文件的表格第一列提取（去掉 `/` 前缀）

计算差集：
- `missing = actual_set - documented_set`（有但未记录）
- `extra = documented_set - actual_set`（已删除但仍在文档中）

**输出格式**：
```
Check 2: Completeness
  Missing from docs:
    skill: data-scraper-agent
    command: pm2
  Extra in docs (removed from ECC):
    (none)
  → FAIL (2 missing)
```

---

### Check 3 — 描述准确性（Description Accuracy）

**方法**：LLM 语义判断，每批 20 条。

对每条，对比：
- **源**：ECC SKILL.md/agent md 中的 `description` frontmatter（英文）
- **文档**：docs/ 中对应的中文描述

**判断维度**：
1. 核心功能是否准确传达（不要求逐字翻译，但不能偏差核心用途）
2. 关键技术术语是否正确（语言名称、框架名称、技术概念）
3. 主要动词是否对应（review→审查 ✓，review→修复 ✗）
4. 是否遗漏了重要的触发条件（如 "PROACTIVELY"、"MUST BE USED for"）

**结果等级**：
- `PASS`：准确，无误导
- `WARN`：细节偏差，不影响使用判断
- `FAIL`：核心功能描述错误或严重遗漏

**输出格式**：
```
Check 3: Description Accuracy
  [Batch 1/7: agents 1-20]
    WARN: architect — 文档未体现 "PROACTIVELY" 触发提示
    All others: PASS
  [Batch 2/7 – 7/7]
    PASS (no issues)
  Summary: 1 WARN, 0 FAIL
```

---

### Check 4 — 分类合理性（Classification）

**方法**：对比 config.json 的 skill_categories patterns vs 每个 skill 当前所在的 docs 文件。

**算法**：
1. 对每个 skill，按 config patterns 推断"应该在"的文件
2. 读取当前 docs/ 中该 skill 实际所在的文件
3. 若不匹配 → 标记为 RECLASSIFY
4. 若 skill 未匹配任何 category → 标记为 UNCATEGORIZED

额外检查：
- 是否有新类别应被创建（同一类型未分组 skill 超过 5 个）

**输出格式**：
```
Check 4: Classification
  configure-ecc: in skills-ai-agent.md, config says skills-engineering.md → RECLASSIFY
  All framework skills: correctly placed → PASS
  New category suggestion: none
  Summary: 1 RECLASSIFY
```

---

### Check 5 — 可读性和差异性（Readability & Differentiation）

**5a. 可读性**（逐条检查）：
- 描述汉字数 < description_min_chars（默认8）→ WARN (too short)
- 描述汉字数 > description_max_chars（默认60）→ WARN (too long)
- 是否能在 3 秒内理解"这个工具干什么"（LLM 判断）

**5b. 差异性**（针对 similar_tool_pairs）：

对每个相似对，检查：
1. 两者的文档描述是否体现出关键差异点
2. 仅凭描述，用户能否区分何时用哪个
3. 若描述几乎相同或差异不明显 → FAIL

重点检查对（需在描述中明确体现差异）：
- `continuous-learning` vs `continuous-learning-v2`：v1 提取会话模式，v2 基于本能/置信度机制
- `agent-eval` vs `eval-harness`：前者是"比较不同 Agent"，后者是"评估框架/度量质量"
- `autonomous-loops` vs `continuous-agent-loop`：前者是架构模式参考，后者是持续运行的循环实现
- `agentic-engineering` vs `ai-first-engineering`：前者是个人工程师操作模式，后者是团队/组织运营模式
- `security-review` vs `security-scan`：前者审查代码中的安全漏洞，后者扫描 Claude 配置文件的安全问题

**输出格式**：
```
Check 5: Readability & Differentiation
  5a. Readability:
    strategic-compact: 22 chars → PASS
    plankton-code-quality: 28 chars → PASS
    All 260 items within length limits → PASS

  5b. Differentiation:
    continuous-learning vs continuous-learning-v2: clearly differentiated → PASS
    agent-eval vs eval-harness: both described as "evaluation framework" without
      clear user-facing distinction → FAIL
      Suggestion: agent-eval = "比较多个 AI 编码代理的完成质量（头对头测试）"
                  eval-harness = "为 Claude Code 会话建立正式评估框架和度量体系"
    All other pairs: PASS
  Summary: 1 FAIL (differentiation)
```

---

## Audit 报告格式

报告写入 `docs/audit-report.md`，同时在对话中打印 Summary。

```markdown
# ECC Guide Audit Report

Generated: {UTC 时间}
ECC Source Version: {ECC_VERSION}
Docs Version: {meta.ecc_version}

## Summary

| Check | Status | Issues |
|-------|--------|--------|
| 1. Quantity | PASS/FAIL | N |
| 2. Completeness | PASS/FAIL | N |
| 3. Description Accuracy | PASS/WARN/FAIL | N |
| 4. Classification | PASS/WARN | N |
| 5. Readability & Diff | PASS/FAIL | N |

**Overall: PASS / ACTION REQUIRED**

## Recommended Actions

1. [CRITICAL] ...
2. [MODERATE] ...
3. [MINOR] ...

## Detailed Results

### Check 1: Quantity
...

### Check 2: Completeness
...

### Check 3: Description Accuracy
...

### Check 4: Classification
...

### Check 5: Readability & Differentiation
...
```

---

## 错误处理

| 错误 | 处理方式 |
|------|----------|
| ECC 源不可访问 | 报错并终止，提示设置 local_ecc_path |
| jq 未安装 | 报错：`jq is required. Install with: brew install jq` |
| docs/.meta.json 不存在（Audit 时）| 自动先执行 Update |
| skill 无法分类 | 归入 skills-business.md 兜底，打印警告 |
| command 无 description frontmatter | fallback 读取正文首行，打印 INFO |

---

## 安装方法

将 skill 目录复制到 Claude Code 全局 skills：

```bash
cp -r skill/ecc-guide ~/.claude/skills/ecc-guide
```

或项目级安装：

```bash
cp -r skill/ecc-guide .claude/skills/ecc-guide
```

---

## 配置说明（config.json）

| 字段 | 说明 |
|------|------|
| `ecc_source.local_ecc_path` | 本地 ECC 仓库路径（优先使用，避免网络请求） |
| `ecc_source.repo_url` | ECC GitHub 仓库地址 |
| `ecc_source.fallback_clone_dir` | 无本地路径时的临时克隆目录 |
| `skill_categories` | skill 分类规则（glob 模式匹配） |
| `command_categories` | command 分组规则 |
| `similar_tool_pairs` | 需要差异性校验的工具对 |
| `audit.description_min_chars` | 描述最短汉字数（默认 8） |
| `audit.description_max_chars` | 描述最长汉字数（默认 60） |
| `audit.batch_size` | 描述准确性校验的批次大小（默认 20） |
