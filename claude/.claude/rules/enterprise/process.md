---
paths: ["**/docs/**", "**/scripts/**", "**/Makefile", "**/Justfile", "**/Taskfile*", "**/tools/**", "**/arch/**", "**/ADR/**", "**/rfcs/**", "**/onboarding/**", "**/getting-started/**", "**/docs/architecture/**"]
---

# 流程协作 & 文档 & 脚本

## 团队沟通
- 公开提问 > 私聊
- 问题: 上下文 + 问题 + 已尝试
- 异步优先, 不打断
- 会议: agenda + minutes, 无 agenda 取消
- 决策写 ADR / RFC, 异步讨论
- 反馈: 及时 / 具体 / 公开表扬私下批评

## 架构治理 (ADR)
- 全局决策写 ADR: title / context / decision / consequence
- ADR 在 `docs/architecture/ADR-{nnn}-{title}.md`
- 撤销写新 ADR, 不改旧 ADR
- 分层: Controller → Service → Repository, 不跨层
- 模块间: interface 通信, 不直接依赖实现
- 技术栈: RFC 讨论 + 安全审计

## 文档
- README.md: 项目简介 + 快速开始 + 链接
- CONTRIBUTING.md: 贡献流程 + 代码规范
- docs/: 安装 → 配置 → 快速开始 → API → FAQ
- 每个功能: 1 可 copy-paste 示例
- DRY: 同一信息只维护一份, 其他链接引用
- 文档随代码 branch

## 脚本
- 幂等 + 日志 + 退出码
- `setup.sh` / `dev` / `lint` / `test` / `build` / `deploy`
- 复杂: Python/Go; 简单: bash/just/make
- `set -euo pipefail`, trap cleanup
- 本地 + CI 都能跑

## 新成员
- 环境: `./scripts/setup.sh` 一键跑通
- Week 1: 环境 + 修 1 BUG
- Week 2: 1 small feature + PR
- Week 3: Review 1 PR + 写 1 ADR
- Month 1: 独立 mid-size feature