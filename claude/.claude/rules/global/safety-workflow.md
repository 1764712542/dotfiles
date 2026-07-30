---
paths: ["**/*"]
---

# ── SAFETY & WORKFLOW ──
# 与 CLAUDE.md 重复但保留以确保 Claude Code 加载

## SAFETY
- 绝不执行: rm -rf / sudo / chmod 777 / force-push
- 绝不提交: .env / credentials / 密钥 / token
- 绝不安装: 未明确要求的依赖
- 绝不改动: .gitignore / CI 配置 / Makefile 除非要求