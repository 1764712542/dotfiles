---
paths: ["**/learn/**", "**/tutorial/**", "**/study/**", "**/notes/**"]
---

# 学习模式规则

## 探索
- 先读官方教程/README, 不看二手总结
- 每概念写 1 句 "一句话总结" 验证理解
- 边学边写: 用 example/ 目录存最小可运行 demo

## 笔记
- 文件名: `topic-short-name.md`
- 格式: 问题 → 答案 → 代码 → 参考链接
- 不抄文档: 只记"和我想的不一样"的部分
- git commit 笔记: "learn: <topic>"

## 求助 Claude
- 解释概念: 先给 analogy, 再给 definition
- 帮我 debug: 先贴错误, 再贴代码, 说预期行为
- 对比技术: 给 2-3 个选项 + 场景; 我要选型建议
- code review 我的代码: 找问题, 也给理由

## 检索
- 不重复造轮: 先搜 crates.io / npm / pypi
- 遇到 bug: 先搜 GitHub issues / StackOverflow
- 确定方案后: 看 1-2 个成熟实现再写
