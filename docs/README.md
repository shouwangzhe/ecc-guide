# Everything Claude Code 完整指南

> 基于 [everything-claude-code](https://github.com/everything-claude-code/everything-claude-code) 项目（v0.1.0）的完整资产分析

本指南帮助你快速了解 ECC（Everything Claude Code）的全部能力，包括代理、命令、技能和规则集。

## 目录

- [Agents（代理）](./agents.md) — 27个专业化子代理
- [Commands（斜杠命令）](./commands.md) — 59个快捷命令
- Skills（技能库）— 115个技能，按类别分组：
  - [语言特定技能](./skills-language.md) — Go / Kotlin / Python / Rust / C++ / Java / Swift / TypeScript / Perl
  - [框架技能](./skills-framework.md) — Django / Laravel / Spring Boot / Ktor / Next.js / SwiftUI / Android / Nuxt
  - [架构与工程技能](./skills-engineering.md) — API 设计 / 数据库 / Docker / 部署 / 安全 / TDD
  - [AI 与 Agent 技能](./skills-ai-agent.md) — Claude API / 自主循环 / 企业运维 / 成本优化
  - [内容与业务技能](./skills-business.md) — 文章写作 / 市场研究 / 投资者材料 / 行业领域

## 总览统计

| 类别 | 数量 |
| --- | --- |
| Agents | 27 |
| Commands | 59 |
| Skills | 115 |
| Rules（规则集） | 59 |
| **合计** | **260** |

## Rules 分类

规则集按语言分类，每类包含 coding-style、testing、patterns、hooks、security 5个规则文件：

| 语言 | 规则数 |
| --- | --- |
| common（通用） | 9 |
| Go / Kotlin / Python / Rust / C++ / Java / Swift / TypeScript / Perl / PHP | 各5 |
