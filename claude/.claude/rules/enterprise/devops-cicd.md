---
paths: ["**/.github/workflows/**", "**/Jenkinsfile*", "**/.gitlab-ci.yml", "**/ci/**"]
---

# CI/CD Pipeline

- 每个 PR 自动跑: lint → typecheck → test → build
- stage: lint+typecheck (< 3min) → unit test → integration → build+镜像 → deploy (手动)
- main: CI + review 才合入
- 镜像: 多阶段构建, 显式 tag, 不用 latest

## 部署
- staging 自动部署 (push main)
- production 手动 (Release / 审批)
- 回滚: 一键回滚上个健康版本
- 金丝雀: 先 10% 流量 → 5 min → 全量

## 环境
- dev: 本地, 无 SLA
- staging: 镜像同 production, 数据脱敏
- production: P0 不可用, 需要审批