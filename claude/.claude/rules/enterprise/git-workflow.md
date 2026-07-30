---
paths: ["**/.git/**", "**/.github/**", "**/CODEOWNERS"]
---

# Git & 工作流

## Git 规范
- feature branch; 禁止直接 push main
- 禁止 force-push / 删远程分支 / amend 已 push 提交
- commit msg: why 非 what (如 "fix: cart total overflow" 而非 "update cart")
- stage 前检查 `git status` + `git diff`
- 不提交无关文件 (DS_Store / node_modules / build 产物)
- rebase 交互整理历史; stash 暂存; worktree 多工作区

## 代码与任务关联
- branch: `{type}/{issue-id}-{kebab-desc}`
- commit: `{type}({scope}): #{issue-id} {msg}`
- PR 链接 issue, 自动 close on merge

## Sprint
- 2 周, 容量 = velocity × 0.8
- 每日: 昨天 / 今天 / 阻塞
- 回顾: 好 / 差 / 改
- 技术债: 每 sprint 20% 容量

## Issue
- 标题: `<type>: <summary>` (feat/fix/chore/docs/refactor)
- 描述: 用户故事 + 验收条件 + 技术方案
- 估算: Fibonacci (1/2/3/5/8/13)
- 优先级: P0 阻塞 → P1 重要 → P2 常规 → P3 nice-to-have