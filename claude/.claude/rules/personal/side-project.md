---
paths: ["**/side-projects/**", "**/playground/**", "**/sandbox/**"]
---

# 个人项目规则

## 启动
- README 先写: what / why / how to run
- License: MIT (lib) / AGPL (server)
- git init → .gitignore → first commit
- 最小可行: CLI 先行, UI 之后

## 技术选型
- 后端: Rust / Go / Python (按场景)
- 前端: Next.js (全栈) / Svelte (轻量)
- 样式: Tailwind (默认) / CSS modules (组件库)
- 数据库: SQLite (dev) / pg (prod)
- 部署: fly.io / Railway / Cloudflare Workers

## 迭代
- 不完美主义: 80% 就发布, 之后迭代
- changelog: 每个版本记 what changed
- 版本号: semver 直到 1.0, 之后 fix-only

## 推广
- 发 HN / Reddit / Twitter 前: 读文档, 修 BUG, 写 landing
- landing page: 1 屏说清问题 + 解决 + CTA
- 开源: GitHub Discussions 开, Discord 可选
