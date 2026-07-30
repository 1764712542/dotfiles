---
paths: ["**/*.test.*", "**/*.spec.*", "tests/**", "**/__tests__/**", "**/test/**"]
---

# 测试规范 & 性能

## 测试金字塔
- unit 70%: 纯函数 / service 逻辑
- integration 20%: API / DB / 外部服务
- e2e 10%: 关键用户流程

## 覆盖率
- 新代码 ≥ 80%, 核心路径 ≥ 90%
- 测行为, 不测实现

## 测试规范
- unit: factory / builder, 不连真实 DB
- integration: testcontainers / 独立 schema
- e2e: 独立 staging + 种子数据
- 不共享状态
- 少用 snapshot; 少用 time.sleep(改用 wait/poll)
- 异常路径: 400/401/403/404/500 都测

## 性能测试
- API: p99 < 200ms, p50 < 50ms
- DB: 慢查询 > 100ms 加索引
- 压力: 每周 k6 / wrk baseline