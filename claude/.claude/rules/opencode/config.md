---
paths: ["**/opencode.json", "**/opencode.jsonc", "**/.opencode/**", "**/.config/opencode/**"]
---

# opencode 配置规则

## 编辑配置
- 改前读全部配置, 不盲写
- 不删 `$schema`; 改后 schema 校验
- 不改 provider 密钥 (放 .env 或系统变量)
- 改完 → restart opencode 生效

## opencode.jsonc 字段
- `model`: `"provider/model-id"` 格式
- `agent`: 对象 keyed by name, 非数组
- `mcp[*].command`: 字符串数组, 非单字符串
- `plugin`: 字符串或 `[name, options]` 数组
- `permission`: 插入顺序决定匹配优先级

## 常见节约 token 手段
- `tool_output.max_lines` ≤ 200 (裁剪大输出)
- `compaction.tail_turns` ≥ 10 (保留更多上下文)
- `formatter: false` (省 ~500 token/turn)
- `lsp: false` (按需启, 省 ~1000 token)
