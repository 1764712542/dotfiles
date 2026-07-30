---
paths: ["**/CODEOWNERS", "**/.github/CODEOWNERS", "**/src/**", "**/internal/**"]
---

# 验证命令 & Code Review

## 验证命令
- TS: `npx tsc --noEmit`
- Python: `python -m py_compile`
- Go: `go vet ./...`
- Rust: `cargo check`
- C: `gcc/clang -Wall -Wextra -Werror`
- Shell: `shellcheck`
- Ruby: `rubocop`
- 测试: 按项目 package.json scripts / Makefile
- lint: 按项目配置 (ESLint / Ruff / golangci-lint / cargo clippy)
- 验证不通过 → 修复, 不强制提交

## Code Review
- PR ≤ 400 行; 描述: what + why + 测试步骤
- 自审通过再提
- 24h 响应, 48h 完成
- 关注: 正确性 > 可维护性 > 性能 > 风格
- blocking: BUG/安全/逻辑错误
- should: 可读性/性能
- nit: 命名/格式 (标注 `nit:`)
- squash merge, 合入后删远程分支