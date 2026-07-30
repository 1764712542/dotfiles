# Sub-Agent 教学教程

> 🎯 **目标读者**：你已经了解基本的 AI 编码助手使用，现在想深入理解 Sub-Agent 系统并学会实际使用它。
>
> **前置知识**：了解 `task()` 工具的基本概念，知道什么是「委托」。

---

## 第 1 课：认识 Sub-Agent

### 1.1 最简单的 Sub-Agent 调用

```python
# 这是委托给 explore（代码搜索）子代理
task(
    subagent_type="explore",      # 指定子代理类型
    task_id="",                    # "" = 创建新的 session
    prompt="搜索项目中所有 Markdown 文件"
)
```

当你执行这行代码时，发生的事情是：

```
1. 系统创建一个全新的、独立的 session
2. 在 session 中启动一个「只擅长代码搜索」的 AI 实例
3. 它独立执行搜索，不干扰你的主会话
4. 返回搜索结果
```

### 1.2 关键认知：Sub-Agent ≈ 新会话

每个 Sub-Agent 调用，本质上是**创建一个新的 AI 会话**：

```
主会话（我）        Sub-Agent（explore）
────────────────    ────────────────────
上下文：整个任务    上下文：只有搜索提示
工具：所有工具      工具：只有搜索工具
角色：编排器        角色：搜索专家
```

**这就是隔离的力量**——explore 不会看到你正在改的代码，不会产生干扰。

---

## 第 2 课：三种委托模式

### 2.1 一次性委托（Fire and Forget）

```typescript
// 创建一个新的 Sub-Agent，执行一次任务
task(
    subagent_type="explore",
    task_id="",                    // "" = 新建
    prompt="查找 src/ 下所有用到 JWT 的地方",
    run_in_background=true         // 后台执行，不阻塞
)
```

适用场景：一次性的搜索、查询、简单任务。

### 2.2 会话延续（Session Continuity）

最强大的特性之一——Sub-Agent 可以记住之前的对话：

```typescript
// 第 1 次：创建 session
const result = task(
    subagent_type="executor",
    task_id="",
    prompt="读取 src/auth.ts 并告诉我它的架构"
);
// result.task_id = "ses_abc123"  ← 保存这个 ID

// 第 2 次：继续同一个 session
task(
    task_id="ses_abc123",          // 传入之前的 ID
    prompt="现在把 login 函数重构成使用 async/await"
);

// 第 3 次：继续同一个 session
task(
    task_id="ses_abc123",
    prompt="添加错误处理，然后验证结果"
);
```

**效果**：sub-agent 记得自己之前做了什么，不需要重新读取文件。

> 💡 **为什么重要**：延续调用的 token 消耗降低 70%+，因为不需要重复加载上下文。

### 2.3 并行委托（Parallel Delegation）

```typescript
// 3 个 Sub-Agent 同时执行
task(subagent_type="explore", task_id="", prompt="搜索 A", run_in_background=true);
task(subagent_type="explore", task_id="", prompt="搜索 B", run_in_background=true);
task(subagent_type="explore", task_id="", prompt="搜索 C", run_in_background=true);

// 全部完成后收集结果
task_wait(task_ids=["bg_1", "bg_2", "bg_3"]);
```

**执行时间对比**：
```
顺序执行：A(5s) → B(5s) → C(5s) = 15s
并行执行：A(5s) + B(5s) + C(5s) =  5s
```

---

## 第 3 课：Sub-Agent 的类型与选择

### 3.1 Agent 选择决策树

```
你的任务是什么？
  │
  ├─ 找代码？                 → explore（搜索专家）
  ├─ 查文档？                 → librarian（文档专家）
  ├─ 设计方案？               → architect（架构师）
  ├─ 写代码？                 → executor（执行者）
  ├─ 审查代码？               → code-reviewer（审查官）
  ├─ 修 Bug？                 → debugger（调试专家）
  ├─ 写测试？                 → test-engineer（测试工程师）
  ├─ 写文档？                 → writer（写手）
  ├─ 验证结果？               → verifier（验证员）
  ├─ 复杂逻辑/算法？           → ultrabrain（重度推理）
  ├─ 前端/UI？                → visual-engineering
  ├─ 安全审计？               → security-reviewer
  ├─ 数据分析？               → scientist
  └─ 通用多步骤？              → general / deep
```

### 3.2 用对模型层级

```
简单搜索               → explore（haiku 模型 → 最快最便宜）
标准实现               → executor（sonnet 模型 → 均衡）
架构设计               → architect（opus 模型 → 最强推理）
```

你不需要用架构师去搜索文件，也不需要让搜索专家来设计系统。

---

## 第 4 课：Skills 与 Sub-Agent 的关系

### 4.1 Skills 不是 Sub-Agent

这是一个常见的混淆点：

```
Sub-Agent = 执行者（who）
Skills    = 工作指南（how）

task(
    subagent_type="executor",      ← WHO：执行者
    load_skills=["my-skill"],      ← HOW：按这个指南做
    prompt="写一个 API"            ← WHAT：做什么
)
```

### 4.2 组合示例

```typescript
// 用「安全审查技能」指导 code-reviewer
task(
    subagent_type="code-reviewer",
    load_skills=["security-review"],   // 加载安全审查的工作指南
    prompt="审查这个 PR 的变更"
);

// 用「教学技能」指导 executor 写教程
task(
    subagent_type="writer",
    load_skills=["principle-educator"], // 加载教学指南
    prompt="写一个 Docker 入门教程"
);
```

---

## 第 5 课：配置自定义 Sub-Agent

### 5.1 在 oh-my-openagent.json 中添加

配置文件：`~/.config/opencode/oh-my-openagent.json`

```jsonc
{
  "agents": {
    "my-custom-agent": {
      "description": "我的自定义 Agent - 做特定类型的重构",
      "model": "zen-proxy/deepseek-v4-flash-free",
      "fallback_models": [
        { "model": "zen-proxy/mimo-v2.5-free" }
      ]
    }
  }
}
```

### 5.2 配置说明

| 字段 | 说明 | 示例 |
|------|------|------|
| `description` | Agent 角色描述 | "代码搜索 - 快速文件查找" |
| `model` | 主模型 ID | "zen-proxy/deepseek-v4-flash-free" |
| `fallback_models` | 回退模型列表 | 主模型失败时按顺序尝试 |

### 5.3 编写自定义 Skill

```markdown
---
name: my-refactor-skill
description: 专门用于代码重构的指南
triggers:
  - 重构
  - refactor
---

# My Refactor Skill

## Purpose
指导 Agent 如何进行安全的代码重构。

## Steps
1. 先读取要重构的文件
2. 理解现有逻辑
3. 确定重构目标
4. 分步修改，每步验证
...
```

---

## 第 6 课：实战演练

### 场景：为一个新功能做实现

假设你要实现一个「用户注册」功能：

#### ❌ 错误做法（单一大模型）

```
prompt: "帮我实现用户注册功能，包括前端页面、后端 API、
         数据库模型、表单验证、错误处理、单元测试..."
```

问题：一个模型同时处理这么多方面，每个部分都做不好。

#### ✅ 正确做法（Sub-Agent 编排）

```
Step 1: 用 explore 搜索现有代码风格
Step 2: 用 architect 设计 API 接口
Step 3: 用 executor 实现后端 + 前端（并行）
Step 4: 用 test-engineer 写测试
Step 5: 用 code-reviewer 审查
Step 6: 用 verifier 验证完整性
```

**具体代码：**

```typescript
// Step 1: 搜索现有模式
task(subagent_type="explore", task_id="",
     prompt="搜索项目中已有的 auth 相关代码，包括路由、模型、中间件模式",
     run_in_background=true);

// Step 2: 设计接口（等待 explore 结果后）
task(subagent_type="architect", task_id="",
     prompt="基于项目的 auth 风格，设计用户注册的 API 接口设计");

// Step 3: 并行实现
task(subagent_type="executor", task_id="",
     prompt="实现后端注册 API，包括路由、验证、数据库操作",
     load_skills=["project-style"], run_in_background=true);
task(subagent_type="executor", task_id="",
     prompt="实现前端注册页面，包括表单、验证、错误提示",
     load_skills=["frontend"], run_in_background=true);

// 等待两者完成
task_wait(task_ids=["bg_1", "bg_2"]);

// Step 4: 审查
task(subagent_type="code-reviewer", task_id="",
     prompt="审查注册功能的完整实现，关注安全性");
```

---

## 第 7 课：常见陷阱与最佳实践

### ❌ 陷阱 1：Delegate 所有事

```
// 错误：连最简单的文件读取都委托
task(subagent_type="explore", prompt="读取 README.md");

// 正确：简单操作自己做
read("README.md");
```

**原则**：委托的收益 > 委托的开销时，才委托。

### ❌ 陷阱 2：不用 Session Continuity

```
// 错误：每次新建
task(subagent_type="executor", task_id="", prompt="第一步...");
task(subagent_type="executor", task_id="", prompt="第二步..."); // 重新开始

// 正确：延续会话
task(subagent_type="executor", task_id="", prompt="第一步...");
// 保存返回的 task_id，第二次传入
task(task_id="ses_abc123", prompt="第二步..."); // 接着做
```

### ✅ 最佳实践清单

| 实践 | 说明 |
|------|------|
| **并行优先** | 独立任务永远并行，不要顺序等待 |
| **Session 复用** | 同一个子任务的多次交互用同一个 session ID |
| **Skills 增强** | 复杂任务加载相关技能指导子代理 |
| **模型匹配** | 简单任务用轻模型，复杂任务用重模型 |
| **结果验证** | 委托任务返回后验证结果是否符合预期 |
| **清理资源** | 用完的后台任务用 `background_cancel()` 清理 |
| **不重复搜索** | 委托给 explore 后，不要自己再搜一遍 |
| **明确 prompt** | 告诉子代理：目标 + 约束 + 期望输出格式 |

### ❌ 陷阱 3：不清理后台任务

```typescript
// 错误：后台任务运行中直接结束
task(subagent_type="explore", prompt="...", run_in_background=true);
// 直接返回了... 任务在后台挂着

// 正确：结束前清理
background_cancel(taskId="bg_xxx");
```

---

## 第 8 课：调试 Sub-Agent

### 8.1 查看 Sub-Agent 结果

```typescript
// 获取后台任务输出
background_output(task_id="bg_xxx");
```

### 8.2 检查 Sub-Agent 状态

```typescript
// 列出所有活跃的委托任务
task_list();
```

### 8.3 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| Sub-Agent 返回空 | Prompt 不够具体 | 明确指定输出格式 |
| Sub-Agent 跑偏 | 缺少约束 | 添加「不要做 X」的约束 |
| Sub-Agent 重复工作 | 没传 context | 用 `relevant_tasks` 传递上下文 |
| 模型不响应 | 主模型失败 | 检查 fallback 配置 |

---

## 总结：Sub-Agent 心法

```
不写代码，写 Prompt
不自己干，委托别人干
不顺序等，并行一起跑
不重复建，Session 复用
不搜两次，委托信任
不清零散，Cleanup 收尾
```

**三句话记住 Sub-Agent 哲学：**

1. **分解** → 把大任务拆成小任务
2. **委托** → 每个小任务交给最擅长它的 Agent
3. **验证** → 检查结果是否达标

---

> 📖 下一篇：[Sub-Agent 原理说明](./sub-agent-principles.md) — 深入理解架构设计和设计哲学
