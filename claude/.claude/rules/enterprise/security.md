---
paths: ["**/security/**", "**/auth/**"]
---

# 安全

## 认证
- 密码: bcrypt / argon2
- JWT: 15 min access + 7d refresh
- MFA: 敏感操作强制
- session: 随机 token, HTTP-only cookie

## 授权
- RBAC: role → permission
- 资源隔离: 用户只能读写自己的资源
- admin 操作: 审计日志 + 双人审批

## 数据安全
- PII: 存储 AES-256-GCM, 传输 TLS 1.3
- 密钥: vault / KMS, 不写代码里
- 日志: 脱敏 (手机/邮箱 打星号)

## API 安全
- Rate limit: 全局 + 用户级别
- CORS: 白名单域名
- XSS: 输出编码, Content-Security-Policy
- SQL 注入: 参数化查询 / ORM