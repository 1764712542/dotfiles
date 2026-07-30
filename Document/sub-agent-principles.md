# Sub-Agent 原理说明

> 本文档深入解释 OMC (oh-my-claudecode) / OpenCode 生态中 **Sub-Agent（子代理）** 的核心原理与架构设计。
> 读完本文，你将理解「多智能体编排」的本质，以及为什么需要 Sub-Agent 而不是一个万能 AI。

---

## 1. 什么是 Sub-Agent？

### 1.1 一句话定义

**Sub-Agent（子代理）= 一个专门化、可委托、独立运行的 AI 工作单元。**

它不是另一个独立的 AI 模型——它是在同一个大模型会话中，通过**不同的指令上下文、模型配置和工具权限**来模拟出不同角色的能力。

### 1.2 现实类比

```
传统单体 AI：  一个人做所有事（做饭、扫地、修车、管账）
                  → 每样都会，但没有一样精通

Sub-Agent 系统：一个专业的厨师团队
   ┌─ 主厨（Orchestrator）：分解任务、分配工作、检查结果
   ├─ 配菜师（explore）：快速搜索食材位置
   ├─ 品控师（code-reviewer）：检查菜品质量
   ├─ 研发主厨（architect）：设计新菜品架构
   └─ 甜品师（writer）：做精致的摆盘文案
```

### 1.3 核心洞察

> **Sub-Agent 的威力不在于单个 Agent 有多强，而在于编排（Orchestration）的质量。**

一个好的 Orchestrator 知道：
- **谁**最适合做这个任务
- **什么时候**可以并行
- **什么时候**必须串行
- **结果**是否达到质量标准

---

## 2. 为什么需要 Sub-Agent？

### 2.1 单一模型的局限性

即使是最强的 AI 模型（如 Claude Opus、GPT-4），在一个会话中也面临：

| 问题 | 表现 |
|------|------|
| **上下文污染** | 前一个任务的工具/代码干扰后一个任务 |
| **注意力稀释** | 需要同时关注搜索、编码、测试、文档，顾此失彼 |
| **工具过载** | 一个会话中可用的工具太多，模型选择困难 |
| **角色冲突** | 写代码和审代码是矛盾心态，同一模型难以切换 |

### 2.2 Sub-Agent 的解决方案

| 问题 | Sub-Agent 方案 |
|------|----------------|
| **上下文污染** | 每个 Sub-Agent 有独立的 session，互不干扰 |
| **注意力稀释** | 每个 Sub-Agent 只关注一个维度（搜索/编码/审查） |
| **工具过载** | 每个 Sub-Agent 只加载需要的工具 |
| **角色冲突** | 写代码用 executor，审代码用 code-reviewer，角色分离 |

---

## 3. 双层 Sub-Agent 架构

本系统中有**两层** Sub-Agent 体系同时运行：

### 3.1 第一层：OMC 内置 Agent（task 工具层）

这些是由 `oh-my-claudecode` 插件定义的、通过 `task()` 工具调用的标准子代理：

```
 task(subagent_type="explore", load_skills=[], prompt="...")
```

**完整 Agent 目录：**

| Agent | 用途 | 推荐模型 |
|-------|------|----------|
| `explore` | 快速代码搜索与文件查找 | haiku |
| `analyst` | 需求分析与隐含约束挖掘 | opus |
| `planner` | 执行顺序与计划制定 | opus |
| `architect` | 系统设计、边界与长期权衡 | opus |
| `debugger` | 根因分析与故障诊断 | sonnet |
| `executor` | 实现与重构 | sonnet |
| `verifier` | 完成度验证与证据收集 | sonnet |
| `tracer` | 追踪信息收集与证据捕获 | sonnet |
| `security-reviewer` | 安全边界与漏洞分析 | sonnet |
| `code-reviewer` | 全面的代码审查 | opus |
| `test-engineer` | 测试策略与回归覆盖 | sonnet |
| `designer` | UX 与交互设计 | sonnet |
| `writer` | 文档与简洁内容撰写 | haiku |
| `qa-tester` | 运行时/手动验证 | sonnet |
| `scientist` | 数据分析与统计推理 | sonnet |
| `document-specialist` | SDK/API/框架文档查询 | sonnet |
| `git-master` | 提交策略与历史管理 | sonnet |
| `code-simplifier` | 保持行为的代码简化 | opus |
| `critic` | 计划/设计的挑战与审查 | opus |
| `general` | 通用多步骤任务执行 | sonnet |
| `librarian` | 多仓库分析/远程代码搜索 | sonnet |
| `oracle` | 架构顾问/深层代码分析 | opus |
| `metis` | 技术方案评估与优化建议 | opus |
| `momus` | 代码审查与缺陷检查 | sonnet |

### 3.2 第二层：oh-my-openagent Plugin Agent

通过 `~/.config/opencode/oh-my-openagent.json` 配置，每个 Agent 有独立的**模型路由**和**回退策略**：

```jsonc
{
  "agents": {
    "sisyphus": {
      "description": "主编排器 — 规划、分配、驱动任务完成",
      "model": "zen-proxy/deepseek-v4-flash-free",
      "fallback_models": [
        { "model": "zen-proxy/mimo-v2.5-free" },
        { "model": "zen-proxy/hy3-free" }
      ]
    },
    "oracle": {
      "description": "架构顾问/调试 — 深层代码分析和方案设计",
      "model": "zen-proxy/deepseek-v4-flash-free",
      "fallback_models": [
        { "model": "zen-proxy/mimo-v2.5-free" },
        { "model": "zen-proxy/hy3-free" }
      ]
    }
    // ... 更多 Agent
  }
}
```

**本系统的自定义 Agent：**

| Agent | 角色 | 主模型 | 回退模型 |
|-------|------|--------|---------|
| **sisyphus** | ⭐ 主编排器 | deepseek-v4-flash-free | mimo-v2.5, hy3 |
| **hephaestus** | 深度执行器 | deepseek-v4-flash-free | mimo-v2.5 |
| **oracle** | 架构顾问 | deepseek-v4-flash-free | mimo-v2.5, hy3 |
| **prometheus** | 策略规划师 | deepseek-v4-flash-free | mimo-v2.5, hy3 |
| **metis** | 深度分析师 | deepseek-v4-flash-free | mimo-v2.5, hy3 |
| **momus** | 代码审查官 | mimo-v2.5-free | deepseek, hy3 |
| **sisyphus-junior** | 轻量执行 | mimo-v2.5-free | deepseek, hy3 |
| **explore** | 代码搜索 | hy3-free | deepseek |
| **atlas** | 上下文管理 | hy3-free | deepseek |
| **multimodal-looker** | 多模态视觉 | deepseek-v4-flash-free | hy3 |

### 3.3 Category（分类）系统

除了 Agent 个体，还有 **Category（分类）** 系统用于 `task()` 的模型路由：

| Category | 用途 | 模型 |
|----------|------|------|
| `ultrabrain` | 重度推理 — 算法、架构、复杂逻辑 | deepseek-v4-flash-free |
| `deep` | 深度任务 — 重构、迁移、复杂编码 | deepseek-v4-flash-free |
| `visual-engineering` | UI/前端工程 | deepseek-v4-flash-free |
| `artistry` | 创意/UI设计 | hy3-free |
| `writing` | 文档/注释写作 | hy3-free |
| `quick` | 快速任务 — 单文件修改/简单查询 | hy3-free |
| `unspecified-high` | 未分类重任务兜底 | deepseek-v4-flash-free |
| `unspecified-low` | 未分类轻任务兜底 | hy3-free |

**关键原则：**

```
重任务 → 强模型（deepseek-v4-flash-free）
轻任务 → 轻模型（hy3-free）
创意/写作 → 均衡模型（mimo-v2.5-free / hy3-free）
```

---

## 4. Sub-Agent 的核心机制

### 4.1 委托（Delegation）

委托是 Sub-Agent 系统的核心操作：

```
Orchestrator（我）
  │
  ├── task(subagent_type="explore", ...)    ← 新建一个子代理 session
  │     └── 子代理独立执行，返回结果
  │
  ├── task(task_id="ses_abc123", ...)       ← 继续已有的子代理 session
  │     └── 子代理保留上下文，继续工作
  │
  └── task_wait(task_ids=[...])             ← 等待多个子代理完成
        └── 同步屏障
```

### 4.2 Session 独立

每个 Sub-Agent 有**完全独立的上下文**：
- 独立的对话历史
- 独立的工具调用记录
- 独立的文件操作状态
- 互不干扰

```
主 Session（编排器上下文）
  ├── Sub-Agent Session 1 (explore)    ← 只看搜索相关
  ├── Sub-Agent Session 2 (executor)   ← 只看编码相关
  └── Sub-Agent Session 3 (verifier)   ← 只看验证相关
```

### 4.3 模型路由与容错

```
请求 → 主模型
        ├── 成功 → 返回结果
        └── 失败（401/403/429/超时）
              └── 回退模型 1
                    ├── 成功 → 返回结果
                    └── 失败 → 回退模型 2
                                  └── 失败 → 报错
```

### 4.4 Skills 作为指令增强

Skills（技能）不是 Sub-Agent 本身，而是 **Sub-Agent 的指令模板**：

```
Sub-Agent + Skill = 特化行为

task(subagent_type="executor",
     load_skills=["principle-educator"],   ← 加载额外指令
     prompt="写一个 Rust 教程")
```

技能通过 `load_skills=[]` 参数注入到 Sub-Agent 的上下文，指导其行为。

---

## 5. 编排模式

### 5.1 顺序编排

```
Step 1 → Step 2 → Step 3
```
适用于：有严格依赖关系的任务。

### 5.2 并行编排

```
Step 1 ──┬── Step 2A ──┬── Step 3
         ├── Step 2B ──┤
         └── Step 2C ──┘
```
适用于：独立的任务可以同时执行。

### 5.3 编排器-工作者模式

```
                        ┌── explore（搜索代码）
                        ├── librarian（查文档）
  Orchestrator ──分解───┼── executor（实现A）
                        ├── executor（实现B）
                        └── verifier（验证）

  1. Orchestrator 理解需求
  2. 分解为独立子任务
  3. 并行委托给 Sub-Agent
  4. 收集结果，综合输出
  5. 验证质量
```

这是本系统使用的**默认模式**——Sisyphus（我）作为主编排器。

### 5.4 审查循环

```
  实现 → 审查 → 修复 → 再审 → 通过
                  ↑_________↓ (循环直到通过)
```

适用于：需要质量门禁的关键任务。

---

## 6. 设计原则

### 6.1 关注点分离（Separation of Concerns）

每个 Sub-Agent 只做一件事：
- `explore` 只搜索代码
- `executor` 只实现代码
- `code-reviewer` 只审查代码
- `verifier` 只验证结果

### 6.2 渐进增强（Progressive Enhancement）

```
简单任务 → haiku（轻量模型，快速便宜）
标准任务 → sonnet（均衡模型）
复杂任务 → opus（最强模型，深度推理）
```

### 6.3 故障隔离（Fault Isolation）

一个 Sub-Agent 失败不影响其他 Sub-Agent：
```
并行任务：
  executor-A（崩溃）→ 不影响 executor-B 和 executor-C
  executor-B（成功）→ 结果正常返回
  executor-C（成功）→ 结果正常返回
```

### 6.4 可组合性（Composability）

Sub-Agent 的输出可以作为另一个 Sub-Agent 的输入：
```
explore（找文件）→ executor（改代码）→ verifier（验证修改）
```

### 6.5 会话连续性（Session Continuity）

Sub-Agent 可以跨多轮对话保持状态：
```
第一轮：task(..., task_id="") → 创建 session
第二轮：task(task_id="ses_abc123", ...) → 继续同一 session
第三轮：task(task_id="ses_abc123", ...) → 继续同一 session
```

---

## 7. 与 MCP（Model Context Protocol）的关系

```
Sub-Agent 系统                    MCP
─────────────                   ─────────
编排层                           工具层
决定谁做什么                     提供做什么的能力
delegation 路由                  工具调用
session 管理                     数据源访问
质量验证                         环境交互
```

- Sub-Agent 使用 MCP 工具来执行任务
- MCP 工具不决定谁用它们——Sub-Agent 系统决定
- 两者互补：Sub-Agent = 组织，MCP = 资源

---

## 8. 对比：本系统 vs 其他方案

| 维度 | 本系统（OMC + oh-my-openagent） | 传统单体 AI | AutoGPT / 类似方案 |
|------|--------------------------------|-------------|-------------------|
| **编排方式** | 手动/半自动编排 | 无编排 | 自动循环 |
| **子代理隔离** | 独立 Session | 共享上下文 | 共享上下文 |
| **模型路由** | 细粒度配置 | 单模型 | 单模型 |
| **回退策略** | 多级 Fallback | 无 | 无 |
| **技能系统** | Skills（指令注入） | 无 | 无 |
| **适用场景** | 软件开发全流程 | 单一对话 | 自主探索 |
| **可靠性** | 高（人工在环） | 中 | 低 |

---

## 9. 总结

```
Sub-Agent 系统的本质：

不是「一个 AI 做所有事」，而是「一群专门化的 AI 角色，由编排器
协调，各司其职，共同完成复杂任务」。
```

- **编排器（Orchestrator）** = 项目经理，分解任务、分配资源、检查质量
- **Sub-Agent** = 团队成员，各自专注一个领域
- **Skills** = 标准操作流程（SOP），指导如何执行特定类型的工作
- **MCP 工具** = 工具箱，提供操作环境的能力
