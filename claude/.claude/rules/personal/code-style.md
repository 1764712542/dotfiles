---
paths: ["**/*.{ts,tsx,js,jsx}", "**/*.rs", "**/*.py", "**/*.go", "**/*.rb", "**/*.c", "**/*.h", "**/*.sh", "**/*.bash"]
---

# 个人编码风格 (通用原则)

## 通用原则
- 沿用项目既有约定; 全局规则为 fallback
- 短名 > 长名: `ret` 非 `result`, `cfg` 非 `config`
- 条件早返: 少 else 多 guard clause
- 函数 ≤ 30 行; 超则拆
- switch/match 全覆盖, 不写 default/_
- 不写注释解释 what (代码自明); 写注释解释 why
- 重复 3 次 → 抽象 (DRY)

> 语言细节见 `code-style-lang.md` (同目录自动加载)