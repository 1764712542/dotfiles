---
paths: ["**/*.{ts,tsx,js,jsx}", "**/*.rs", "**/*.py", "**/*.go", "**/*.rb", "**/*.c", "**/*.h", "**/*.sh", "**/*.bash"]
---

# 语言速查 (个人项目)

## TS/JS
- 2-space indent / 单引号 / 无分号 / 尾逗号
- named export > default export
- async/await > .then() / callback
- type > interface (联合/交叉更方便); interface 用于 class
- 枚举用 `as const` + union, 不写 enum 关键字
- 键排序: required → optional → computed
- 错误统一 Error 类, 不抛字面量
- 避免 `any`; 用 `unknown` + 类型收窄 / z.is() / 类型谓词

## Rust
- snake_case; Result<T,E>; ? > unwrap
- 错误: thiserror + anyhow (lib用thiserror, bin用anyhow)
- unwrap 仅 test / prototype; 生产用 ?
- struct 用 `Self::new()` 构造, 不用 public field

## Python
- f-strings > %/+; with; 类型注解
- import 顺序: stdlib > 三方 > 本地 (空行分隔)
- Python 3.10+ union `X | Y` 非 `Union[X, Y]`
- dataclass > 手写 __init__
- 路径: pathlib.Path > os.path
- 测试: pytest (test_*.py)
- 验证: `ruff check . && mypy .`

## Go
- error 处理/返回; 驼峰; pkg 名不加前缀
- 错误: `fmt.Errorf("context: %w", err)` 带 wrap
- 接收者: 值类型传值, 指针类型传指针
- interface 定义在 consumer 方, 非 producer
- 验证: `go vet ./... && go fmt ./...`

## C
- int(0=ok,-1=err); #ifndef 守卫; const 指针; caller free
- 验证: `gcc/clang -Wall -Wextra -Werror`

## Shell
- "双引号"; set -euo pipefail; [[ ]] > [ ]; local
- 验证: `shellcheck`

## Ruby
- 2-space; snake_case; CamelCase; frozen_string_literal: true; &. 安全导航
- 验证: `rubocop`