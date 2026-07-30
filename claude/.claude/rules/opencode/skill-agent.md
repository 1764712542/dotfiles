---
paths: ["**/.claude/skills/**", "**/.opencode/skills/**", "**/.opencode/agent*/**"]
---

# opencode Skill & Agent 规则

## Skill 规范
- 文件名: `SKILL.md`, 在 `{skill-name}/SKILL.md`
- frontmatter: `name` / `description` (必填)
- description: 写 "Use when..." 标明触发场景
- 描述前置具体关键词; 用 "Use ONLY when..." 收窄

## Agent 规范
- 文件: `.opencode/agents/{name}.md`
- frontmatter: `description / mode / model / permission`
- mode: subagent / primary / all
- permission 覆盖全局 (如 reviewer 禁止 edit)
- file body 即 prompt, 不放 `prompt:` 在 frontmatter

## 文件名约束
- skill name: 小写 + 连字符, ≤ 64 字符
- 对应目录名: 和 frontmatter name 一致

## 注册
- skill: opencode.json 的 `skills.paths` 或自动扫描
- agent: opencode.json 的 `agent` 字段或文件自动发现
- plugin: `.opencode/plugin/*.ts` 自动加载
