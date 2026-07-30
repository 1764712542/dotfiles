---
paths: ["**/api/**", "**/services/**", "**/*.proto", "**/openapi.*", "**/swagger.*"]
---

# 后端 API 设计

## REST
- URL: 复数名词 `/api/v1/users`
- 动作: GET/POST/PUT/PATCH/DELETE
- 查询: `?sort=created_at&order=desc&page=1&per_page=20&filter[status]=active`
- 响应: `{ ok: bool, data?, error?: { code, message, details? }, meta?: { page, total, ... } }`

## GraphQL
- query 读 / mutation 写 / subscription 实时
- 分页: Connection spec
- N+1: DataLoader / batch load

## gRPC
- proto3, package 按服务名
- 错误: gRPC status codes
- 流式: server streaming > polling
- 网关: gRPC-gateway 生成 REST 转接

## 版本 & 文档
- URL prefix (`/api/v1/`) 或 Accept header
- 向前兼容: 加字段不改字段, 不删字段
- 废弃: Deprecated 标注 + 提前 1 月通知
- OpenAPI 3.0 / AsyncAPI, 每个 endpoint 带示例
- 合同测试: provider Pact, consumer mock