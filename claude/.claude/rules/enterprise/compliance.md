---
paths: ["**/compliance/**", "**/audit/**", "**/sla/**", "**/legal/**", "SECURITY.md"]
---

# 合规 & 审计 & SLA

## 数据保护 (GDPR / CCPA / PIPL)
- 收集前告知 + 同意
- 用户可下载/删除自己的所有数据
- 数据不离开指定区域

## 审计
- admin 操作记审计日志 (who/what/when/result)
- 不可篡改 (append-only / WORM)
- 季度权限审计

## 财务合规 (SOX / PCI-DSS)
- 支付: 不经手卡号 (Stripe / Adyen)
- 财务操作: 双人审批
- 所有生产变更走审批

## SCA & 许可
- SCA 扫描: 每次 build
- 高危 CVE: 24h 修复
- 依赖: 检查 License 兼容性
- 专有代码不开源 (除非特批)
- SBOM: 每次 release 生成

## SLA
- uptime: 99.9% (8.77h/yr max)
- 响应: P0 15min / P1 1h / P2 4h / P3 24h