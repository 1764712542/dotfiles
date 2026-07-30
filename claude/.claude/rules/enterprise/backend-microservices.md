---
paths: ["**/services/**", "**/microservices/**", "**/logging/**", "**/log/**"]
---

# 微服务 & 日志

## 微服务
- 1 服务 = 1 业务能力 (bounded context)
- 服务间: API / Event 通信, 不共享 DB
- 同步: gRPC (内部) / REST (外部)
- 异步: 事件总线 (Kafka / RabbitMQ / NATS)
- 重试: exponential backoff + jitter (max 3)
- 熔断: circuit breaker (失败率 > 50% → open)
- 事件: `{Domain}.{Action}.{Version}`, 幂等消费
- 服务发现: K8s Service / Consul
- 配置中心: etcd / Consul / 环境变量

## 日志
- JSON 结构化: `{ time, level, service, trace_id, message, data? }`
- 时间: ISO 8601 UTC + 毫秒
- 级别: trace / debug / info / warn / error / fatal
- error: 含 stack trace + 上下文
- 不 log sensitive data
- 日志量: error < warn < info; debug 不上生产
- 轮转: 100MB 本地, 集中式远端 (ELK / Loki)
- 保留: 30 天热 + 1 年冷
- 审计日志: WORM 存储, 不可删除