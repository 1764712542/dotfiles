---
paths: ["**/.claude/rules/**"]
---

# ~/.claude/rules 索引

## 加载优先级
1. global/ - 通用规则 (所有项目)
2. enterprise/ - 企业级 (需 `.claude-enterprise` 标识)
3. personal/ - 个人项目 (按目录匹配)
4. opencode/ - opencode 配置

## 文件清单

### global/ (paths: **/*)
- safety-workflow.md - 安全红线 + 工作流
- communication.md - 沟通 + 智能默认
- token-optimization.md - Token 优化
- local-ops.md - macOS 运维
- editors.md - 编辑器配置

### enterprise/ (需显式启用)
- process.md - 协作/文档/脚本/ADR
- git-workflow.md - Git/Sprint/Issue
- frontend.md - 前端/可访问性/i18n/性能
- security.md - 认证/授权/数据/API
- compliance.md - GDPR/审计/财务/SCA/SLA
- devops-cicd.md - CI/CD/部署/环境
- devops-infra.md - K8s/Docker/Terraform
- devops-observability.md - 监控/告警/故障/依赖
- backend-api.md - REST/GraphQL/gRPC/版本
- backend-data.md - Schema/Migration/查询/事务
- backend-microservices.md - 微服务/日志
- quality-code.md - 命名/函数/错误/并发
- quality-testing.md - 测试金字塔/覆盖率/性能
- quality-review.md - 验证命令/Code Review

### personal/
- code-style.md - 通用原则
- code-style-lang.md - 8语言速查
- learning.md - 学习/笔记/求助
- opensource.md - 贡献/PR/行为
- side-project.md - 启动/选型/迭代/推广

### opencode/
- skill-agent.md - Skill/Agent 规范
- config.md - opencode.json 编辑
- rules-design.md - 规则编写指南

## 启用企业级
```bash
touch .claude-enterprise
# opencode.json: { "rules": { "paths": [".claude/rules/enterprise"] } }
```

## Token 预估
- 个人学习: global(3)+personal(1-2) ~250
- 个人副业: global(3)+personal(2) ~330
- 企业前端: global(3)+enterprise(3) ~550
- 企业全栈: global(3)+enterprise(6) ~900
- 配置 opencode: global(3)+opencode(3) ~350

## 维护
```bash
wc -l global/*.md enterprise/*.md personal/*.md opencode/*.md INDEX.md
grep -r "^paths:" --include="*.md" | sort
```
---
*动态文件数量与行数会变化；需要时请用下方维护命令重新统计。*
