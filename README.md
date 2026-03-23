# ecc-guide

Everything Claude Code（ECC）的完整中文指南，包含 27 个代理、59 个命令、115 个技能和 59 个规则集的详细说明。同时提供一个三合一 skill，用于自动更新和审核文档。

基于 [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code)。

## 阅读文档

直接浏览 [docs/](./docs/) 目录：

| 文件 | 内容 |
|------|------|
| [docs/README.md](./docs/README.md) | 总览和统计 |
| [docs/agents.md](./docs/agents.md) | 27 个专业化代理 |
| [docs/commands.md](./docs/commands.md) | 59 个斜杠命令 |
| [docs/rules.md](./docs/rules.md) | 59 个规则文件 |
| [docs/skills-language.md](./docs/skills-language.md) | 语言特定技能（Go/Kotlin/Python/Rust/C++/Java/Swift/Perl） |
| [docs/skills-framework.md](./docs/skills-framework.md) | 框架技能（Django/Laravel/Spring Boot/Next.js/SwiftUI/Nuxt） |
| [docs/skills-engineering.md](./docs/skills-engineering.md) | 架构与工程技能（API/数据库/Docker/安全/TDD） |
| [docs/skills-ai-agent.md](./docs/skills-ai-agent.md) | AI 与 Agent 技能（Claude API/自主循环/评估/学习） |
| [docs/skills-business.md](./docs/skills-business.md) | 内容与业务技能（写作/研究/媒体/行业领域） |

## 安装 Skill

将 skill 安装到 Claude Code 后，可以直接对话来更新和审核文档：

```bash
# 全局安装（推荐）
cp -r skill/ecc-guide ~/.claude/skills/ecc-guide

# 或项目级安装
cp -r skill/ecc-guide .claude/skills/ecc-guide
```

> **依赖**：脚本需要 `jq` 和 `git`。macOS 安装：`brew install jq`

## 使用 Skill

安装后，在 Claude Code 中直接说：

| 你说 | 执行的操作 |
|------|-----------|
| `update ecc-guide` | 拉取最新 ECC → 重新生成所有 docs/ 文件 |
| `audit ecc guide` | 运行 5 项校验，输出审核报告 |
| `full update and audit` | 更新 + 审核，完整流程 |

### 更新流程

```
ECC Guide Update
─────────────────────────────────────────
Source:  /path/to/everything-claude-code  (local)
Version: 1.9.0

Scanning...
  ✓ agents:   27
  ✓ commands: 59
  ✓ skills:   116
  ✓ rules:    60

Generating docs/
  ✓ agents.md, commands.md, skills-*.md, .meta.json, README.md

Done. 9 files updated.
```

### 审核校验（5项）

| 校验 | 内容 |
|------|------|
| 1. 数量校验 | 实际文件数 vs docs 中的统计数字 |
| 2. 完整性校验 | 每个 skill/agent/command 都在文档中 |
| 3. 描述准确性 | 中文描述是否准确传达英文源描述的核心功能 |
| 4. 分类合理性 | skill 是否放在了正确的类别文件中 |
| 5. 可读性和差异性 | 描述是否清晰，相似工具的区别是否明确 |

审核结果保存至 `docs/audit-report.md`。

## 配置

编辑 `skill/ecc-guide/config.json`：

```json
{
  "ecc_source": {
    "local_ecc_path": "/your/path/to/everything-claude-code"
  }
}
```

设置 `local_ecc_path` 可跳过网络拉取，直接使用本地已有的 ECC 仓库。

## 仓库结构

```
ecc-guide/
├── docs/                    # Guide 文档（供阅读）
│   ├── README.md
│   ├── agents.md
│   ├── commands.md
│   ├── skills-*.md
│   └── .meta.json           # 版本快照
└── skill/
    └── ecc-guide/           # Claude Code Skill
        ├── SKILL.md         # Skill 主文件（含完整 Update + Audit 逻辑）
        ├── config.json      # 分类规则和配置
        └── scripts/
            ├── fetch-ecc.sh
            ├── scan-ecc.sh
            └── audit-counts.sh
```

## 如何更新本仓库

当 ECC 发布新版本后，使用 skill 自动更新文档：

### 1. 进入仓库目录

```bash
cd /Users/lvpengbin/ecc-guide
git pull origin master
```

### 2. 在 Claude Code 中触发更新

直接对话：

```
full update and audit
```

Skill 会自动：
- 拉取最新 ECC 仓库
- 扫描所有 agents/commands/skills/rules
- 重新生成 `docs/` 下的所有文件
- 运行 5 项审核校验

### 3. 提交并推送

```bash
git add docs/
git commit -m "Update docs to ECC v{version}"
git push origin master
```

### 快速参考

| 命令 | 说明 |
|------|------|
| `update ecc-guide` | 只更新文档，不审核 |
| `audit ecc guide` | 只审核，不更新 |
| `full update and audit` | 完整流程（推荐） |

审核报告保存在 `docs/audit-report.md`。

## License

MIT
