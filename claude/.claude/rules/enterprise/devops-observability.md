---
paths: ["**/monitoring/**", "**/grafana/**", "**/prometheus/**", "**/datadog/**", "**/alertmanager/**", "**/incident/**", "**/on-call/**", "**/runbook/**", "**/postmortem/**"]
---

# 监控 & 告警 & 故障响应

## Metrics
- RED: Rate / Errors / Duration (每 endpoint)
- USE: Utilization / Saturation / Errors (每资源)
- 业务: 订单量 / 注册量 / 支付成功率

## 告警
- P0: 服务宕机 → 即时电话
- P1: 错误率 > 5% → 即时 IM
- P2: 延迟 > p99 3x → 工作时间
- P3: 磁盘 > 80% → 周报
- 无对应操作 → 删规则

## SLO
- 用户面: uptime 99.9% / p99 < 500ms
- 错误预算: 消耗 > 50% 冻结新功能

## 故障响应
- SEV0: 核心服务不可用 → 全员
- SEV1: 主要功能受损 → 值班
- SEV2/3: 非核心 / 小 BUG
- 流程: 发现 → 定级 → 止血 → 缓解 → 复盘
- Postmortem: 48h, 5 Whys, blame-free

## 依赖管理
- 最小依赖, 固定版本 (lockfile 必提交)
- 每次新增做安全审查
- 安全更新即时, 日常更新每周 (Dependabot)
- 审计: `npm audit` / `cargo audit` / `safety check`
- 许可证扫描, SBOM (CycloneDX)