# Commands（斜杠命令）

共 59 个斜杠命令，在 Claude Code 中以 `/命令名` 方式调用。

---

## 语言构建与审查命令

| 命令 | 作用 |
| --- | --- |
| /go-build | 调用 go-build-resolver 代理增量修复 Go 构建错误、go vet 警告和 linter 问题 |
| /go-review | 调用 go-reviewer 代理对 Go 代码进行惯用模式、并发安全、错误处理和安全的全面审查 |
| /go-test | 强制执行 Go TDD 工作流，先写表格驱动测试再实现，用 go test -cover 验证覆盖率 |
| /kotlin-build | 调用 kotlin-build-resolver 代理增量修复 Kotlin 构建错误 |
| /kotlin-review | 调用 kotlin-reviewer 代理对 Kotlin 代码进行惯用模式、空安全、协程安全和安全的全面审查 |
| /kotlin-test | 强制执行 Kotlin TDD 工作流，先写 Kotest 测试再实现，用 Kover 验证覆盖率 |
| /rust-build | 调用 rust-build-resolver 代理增量修复 Rust 构建错误和借用检查器问题 |
| /rust-review | 调用 rust-reviewer 代理对 Rust 代码进行所有权、生命周期、错误处理和惯用模式的全面审查 |
| /rust-test | 强制执行 Rust TDD 工作流，先写测试再实现，用 cargo-llvm-cov 验证覆盖率 |
| /cpp-build | 调用 cpp-build-resolver 代理增量修复 C++ 构建错误、CMake 问题和链接器问题 |
| /cpp-review | 调用 cpp-reviewer 代理对 C++ 代码进行内存安全、现代惯例、并发和安全的全面审查 |
| /cpp-test | 强制执行 C++ TDD 工作流，先写 GoogleTest 测试再实现，用 gcov/lcov 验证覆盖率 |
| /python-review | 调用 python-reviewer 代理对 Python 代码进行 PEP 8 合规性、类型提示、安全和 Pythonic 惯用法的全面审查 |
| /gradle-build | 增量修复 Android 和 KMP 项目的 Gradle 构建错误 |
| /build-fix | 以最小安全变更增量修复构建和类型错误 |
| /tdd | 调用 tdd-guide 代理强制执行测试驱动开发工作流 |
| /e2e | 调用 e2e-runner 代理生成并运行 Playwright 端到端测试 |
| /test-coverage | 分析测试覆盖率、识别缺口并生成缺失测试以达到 80%+ 覆盖率 |

---

## 代码质量命令

| 命令 | 作用 |
| --- | --- |
| /code-review | 对未提交变更进行全面的安全和质量审查 |
| /refactor-clean | 安全识别和删除死代码，每步都进行测试验证 |
| /quality-gate | 按需对文件或项目范围运行 ECC 质量流水线 |
| /prompt-optimize | 分析草稿 Prompt 并输出针对 ECC 优化的版本（仅分析，不执行任务） |
| /learn | 分析当前会话并提取值得保存为技能的模式 |
| /learn-eval | 从会话中提取可复用模式，自我评估质量后再保存，并确定正确的保存位置 |
| /rules-distill | 扫描技能以提取跨领域原则并将其提炼为规则 |
| /skill-create | 分析本地 git 历史以提取编码模式并生成 SKILL.md 文件 |
| /update-codemaps | 分析代码库结构并生成精简的架构文档 |
| /update-docs | 从源文件生成并同步文档与代码库 |
| /verify | 对当前代码库运行全面验证（构建、类型检查、lint、测试、console.log 审计、git 状态） |

---

## 工作流编排命令

| 命令 | 作用 |
| --- | --- |
| /plan | 调用 planner 代理重述需求、评估风险并创建分步实施计划，等待用户确认后再编码 |
| /orchestrate | 复杂任务的顺序代理工作流，支持 tmux/工作树编排 |
| /devfleet | 通过 Claude DevFleet 编排并行 Claude Code 代理，在隔离的工作树中运行 |
| /claw | 启动 NanoClaw v2 — ECC 的持久化零依赖 REPL，支持模型路由、技能热加载、分支、压缩、导出和指标 |
| /checkpoint | 在工作流中创建或验证检查点 |
| /aside | 在不中断当前任务的情况下回答临时问题，回答后自动恢复工作 |
| /loop-start | 以安全默认设置启动受管理的自主循环模式 |
| /loop-status | 检查活动循环状态、进度和失败信号 |
| /multi-plan | 多模型协作规划 — 上下文检索 + 双模型分析 → 生成分步实施计划 |
| /multi-execute | 多模型协作执行 — 从计划获取原型 → Claude 重构和实现 → 多模型审计和交付 |
| /multi-backend | 后端专注的开发工作流（研究→构想→计划→执行→优化→审查），由 Codex 主导 |
| /multi-frontend | 前端专注的工作流（研究→构想→计划→执行→优化→审查），由 Gemini 主导 |
| /multi-workflow | 多模型协作开发工作流，智能路由：前端→Gemini，后端→Codex |
| /pm2 | 自动分析项目并生成 PM2 服务命令和配置文件 |
| /evolve | 分析本能并建议或生成进化结构（命令/技能/代理） |

---

## 会话管理命令

| 命令 | 作用 |
| --- | --- |
| /save-session | 将当前会话状态保存到 ~/.claude/sessions/ 中的日期文件，以便下次会话恢复 |
| /resume-session | 从 ~/.claude/sessions/ 加载最近的会话文件并恢复完整上下文 |
| /sessions | 管理 Claude Code 会话历史、别名和会话元数据 |

---

## 配置与管理命令

| 命令 | 作用 |
| --- | --- |
| /context-budget | 分析代理、技能、MCP 服务器和规则的上下文窗口使用情况以找到优化机会 |
| /model-route | 根据复杂度和预算推荐当前任务最合适的模型层级 |
| /instinct-status | 显示已学习的本能（项目+全局）及其置信度 |
| /instinct-export | 将本能从项目/全局范围导出到文件 |
| /instinct-import | 从文件或 URL 导入本能到项目/全局范围 |
| /promote | 将项目范围的本能提升到全局范围 |
| /skill-health | 显示技能组合健康仪表板，包含图表和分析 |
| /harness-audit | 运行确定性仓库 harness 审计并返回优先级评分卡 |
| /projects | 列出已知项目及其本能统计信息 |
| /docs | 通过 Context7 查找库或主题的最新文档 |
| /setup-pm | 配置首选包管理器（npm/pnpm/yarn/bun） |
| /eval | 管理评估驱动的开发工作流 |
