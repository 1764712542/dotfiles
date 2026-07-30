---
paths: ["**/*"]
---

# ── macOS / LOCAL OPS ──
# 核心规则见 CLAUDE.md, 此处仅 Ops 补充

## Ops
- `defaults write` (先 read 当前值)
- `brew update && upgrade`
- `launchctl` 管理 agent/service
- .dmg 从 App Store 或 `brew install --cask` 装