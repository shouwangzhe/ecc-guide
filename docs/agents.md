# Agents（代理）

共 28 个专业化子代理，可被主 Claude 自动调用。

---

## 语言特定代理

| # | 代理名称 | 语言 | 作用 |
| --- | --- | --- | --- |
| 1 | go-reviewer | Go | 审查惯用 Go 风格、并发模式、错误处理和性能 |
| 2 | go-build-resolver | Go | 修复 Go 构建错误、go vet 警告和 linter 问题 |
| 3 | kotlin-reviewer | Kotlin | 审查惯用模式、空安全、协程安全和 Compose 最佳实践 |
| 4 | kotlin-build-resolver | Kotlin | 修复 Kotlin/Gradle 构建、编译和依赖错误 |
| 5 | python-reviewer | Python | 审查 PEP 8 合规性、Pythonic 惯例、类型提示、安全和性能 |
| 6 | java-reviewer | Java | 审查分层架构、JPA 模式、安全和并发（Spring Boot 项目必用） |
| 7 | java-build-resolver | Java | 修复 Java/Maven/Gradle 构建、编译和依赖错误 |
| 8 | rust-reviewer | Rust | 审查所有权、生命周期、错误处理、unsafe 用法和惯用模式 |
| 9 | rust-build-resolver | Rust | 修复 Rust 构建、借用检查器问题和 Cargo.toml 错误 |
| 10 | cpp-reviewer | C++ | 审查内存安全、现代 C++ 惯例、并发和性能 |
| 11 | cpp-build-resolver | C++ | 修复 C++ 构建、CMake 和链接器问题 |
| 12 | typescript-reviewer | TypeScript/JS | 审查类型安全、异步正确性、Node/Web 安全和惯用模式 |
| 13 | pytorch-build-resolver | PyTorch | 修复 PyTorch 运行时、CUDA 和训练错误（张量形状、梯度问题等） |
| 14 | database-reviewer | SQL/Supabase | PostgreSQL 查询优化、模式设计、安全和性能 |
| 15 | flutter-reviewer | Flutter/Dart | 审查 Flutter 组件最佳实践、状态管理模式、Dart 惯例、性能陷阱和无障碍性 |

---

## 通用工程代理

| # | 代理名称 | 作用 |
| --- | --- | --- |
| 1 | architect | 系统架构设计、可扩展性规划和技术决策 |
| 2 | planner | 复杂功能和重构的规划，创建详细可执行的实施计划 |
| 3 | code-reviewer | 通用代码质量、安全性和可维护性审查 |
| 4 | security-reviewer | 安全漏洞检测，覆盖 OWASP Top 10、SSRF、注入、不安全加密等 |
| 5 | tdd-guide | 测试驱动开发专家，强制先写测试，确保 80%+ 覆盖率 |
| 6 | refactor-cleaner | 死代码清理和合并，运行 knip/depcheck/ts-prune 识别并安全删除未使用代码 |
| 7 | build-error-resolver | 通用构建和 TypeScript 错误修复，以最小变更快速让构建变绿 |
| 8 | doc-updater | 文档和代码地图专家，运行 /update-codemaps 和 /update-docs 保持文档同步 |
| 9 | docs-lookup | 通过 Context7 MCP 获取最新库/框架/API 文档并返回带示例的答案 |
| 10 | e2e-runner | 端到端测试专家，优先使用 Vercel Agent Browser，备用 Playwright |
| 11 | loop-operator | 运行自主代理循环，监控进度，在循环停滞时安全介入 |
| 12 | harness-optimizer | 分析和改进本地代理 harness 配置，提升可靠性、成本效率和吞吐量 |
| 13 | chief-of-staff | 个人通讯参谋，统一处理邮件、Slack、LINE 和 Messenger 的分类与回复 |
