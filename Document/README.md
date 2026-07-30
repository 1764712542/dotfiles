# Document — Sub-Agent 原理与教程

本目录包含关于 **OMC (oh-my-claudecode) / OpenCode Sub-Agent 系统**的原理说明和教学教程。

## 文件索引

| 文件 | 内容 | 适合谁看 |
|------|------|----------|
| **[sub-agent-principles.md](./sub-agent-principles.md)** | Sub-Agent 的原理、架构、设计哲学 | 想深入理解系统设计的技术人员 |
| **[sub-agent-tutorial.md](./sub-agent-tutorial.md)** | 手把手教学：如何使用 Sub-Agent | 想学习实际使用的开发者 |

## 学习路径

### 路径 A：从零开始
```
1. sub-agent-tutorial.md  — 先学怎么用（实操）
2. sub-agent-principles.md — 再理解为什么这样设计（原理）
```

### 路径 B：技术深究
```
1. sub-agent-principles.md — 先理解架构和设计理念
2. sub-agent-tutorial.md  — 再动手实践
```

## 内容概要

**Sub-Agent** = 专门化、可委托、独立运行的 AI 工作单元。

本系统有两层 Sub-Agent 体系：
- **OMC 内置 Agent**（通过 `task()` 调用）：explore、executor、architect、code-reviewer 等 20+ 种
- **oh-my-openagent 自定义 Agent**（通过 JSON 配置模型路由）：sisyphus、oracle、metis、momus 等

核心能力：
- 并行委托 → 速度提升 N 倍
- Session 独立 → 上下文无污染
- 模型路由 → 任务匹配最合适的模型
- Skills 注入 → 灵活的行为定制

## 相关源码

- `~/.config/opencode/oh-my-openagent.json` — Sub-Agent 模型路由配置
- `~/.claude/skills/` — 技能定义
- `.opencode/skills/` — 项目级技能