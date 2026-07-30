---
paths: ["**/.claude/rules/**"]
---

# CLAUDE.md 规则编辑指南

## 设计原则
- 每文件 ≤ 50 行; 超了拆
- 每条规则问 "删了 Claude 会犯错吗?" 不会就删
- paths frontmatter 精准匹配, 不写 `**/*` 除非通用
- 最前放 `# ── SECTION NAME ──` 分割清晰

## 格式节省 token
- 用 `-` 列表, 不用表格/段落
- 省略冠词 (the/a/an) 和句号
- 用缩写: TS / JS / DB / API / CI / config / env
- 指令紧凑: "改旧不写新" 而非 "优先使用 Edit 而非 Write"
- 安全/重要规则: 前缀 `[IMPORTANT]`

## 规则结构
- 优先级: SAFETY > Workflow > Style > Verification > Communication
- 每 section 第 1 行最关键的规则 (Claude 更注意开头)
- allowlist > blocklist: "feature branch" 而非 "不要直接改 main"
- 重要规则带 why: 说理由 Claude 才能泛化

## 验证
- `wc -l *.md` 检查行数
- 检查 paths 是否有冲突 / 遗漏
- 检查是否和 CLAUDE.md 全局规则矛盾
