---
paths: ["**/src/**", "**/internal/**", "**/lib/**"]
---

# 代码质量: 命名/函数/错误/并发

## 命名
- 类/类型: PascalCase, 名词
- 函数/方法: camelCase, 动词/动宾
- 常量: UPPER_SNAKE
- 布尔: is/has/should 前缀

## 函数
- 单一职责
- 参数 ≤ 3; 超则封装为 options object
- 纯函数优先; 副作用命名体现 (saveXxx / sendXxx)

## 错误处理
- 层层包装, 不吞错误
- 外部错误: 统一 error code + 用户友好消息
- panic/throw: 只在不可恢复时用

## 并发
- goroutine/task/thread: 明确生命周期
- 资源: defer / finally 释放
- 锁: 最小范围, 避免嵌套锁