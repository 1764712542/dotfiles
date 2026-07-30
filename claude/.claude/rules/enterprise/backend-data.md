---
paths: ["**/migrations/**", "**/seed/**", "**/schema/**", "**/prisma/**", "**/typeorm/**", "**/sqlx/**", "**/*.sql"]
---

# 数据库 & Schema & Migration

## Schema
- 主键: UUIDv7 / snowflake
- 时间: timestamptz UTC, `created_at / updated_at`
- 软删除: `deleted_at` 索引, 查询默认 `WHERE deleted_at IS NULL`
- 枚举: CHECK 约束或引用表, 不硬编码 ENUM

## Migration
- 1 migration = 1 原子变更 (可回滚)
- 不改已合入的 migration
- 大表 DDL: pt-online-schema-change / gh-ost

## 查询 & 事务
- N+1 自动检测: eager loading / batch
- 索引: WHERE / JOIN / ORDER BY 列必须有索引
- 复合索引: 高选择性列在前
- 分页: cursor-based, 不用 OFFSET
- 短事务 < 1s; 长事务拆 batch
- 隔离: READ COMMITTED (默认), SERIALIZABLE (财务)
- 分布式: Saga / TCC