---
paths: ["**/CONTRIBUTING.md", "**/CODE_OF_CONDUCT.md", "**/.github/**"]
---

# 开源贡献规则

## 贡献前
- 读 CONTRIBUTING.md + README 了解约定
- fork 后 sync main, 从 main 切 feature branch
- 小改直接 PR; 大改先开 issue 讨论

## PR
- 标题: `<type>: <brief>` (feat/fix/docs/refactor)
- 描述: what + why + 测试方式 + screenshots(UI)
- 单 PR 解决一个问题, 不混杂
- rebase 而非 merge main (保持线性历史)

## Review
- reviewer 限定 1-2 人, 不 CC 所有人
- 回复 every comment; acknowledge 或 discuss
- 改动请求: 修完 mark resolved
- 24h 无回复 → ping

## 行为
- 友善第一: 假设善意, 不说"you're wrong"
- 反馈提建议: "consider using X" 而非 "this is bad"
- 坚持不下去: 写 help wanted 或 close gracefully
