# OpenCode 安装与使用指南

> OpenCode 是一个开源的 AI 编码代理（coding agent），可在终端、桌面或 IDE 中使用。
> 官网: https://opencode.ai · GitHub: https://github.com/anomalyco/opencode

---

## 目录

1. [安装](#1-安装)
2. [配置模型提供商](#2-配置模型提供商)
3. [启动与初始化](#3-启动与初始化)
4. [TUI 界面操作](#4-tui-界面操作)
5. [斜杠命令](#5-斜杠命令)
6. [快捷键](#6-快捷键)
7. [CLI 命令行模式](#7-cli-命令行模式)
8. [配置文件](#8-配置文件)
9. [自定义命令](#9-自定义命令)
10. [AGENTS.md 规则](#10-agentsmd-规则)
11. [常见问题](#11-常见问题)

---

## 1. 安装

### macOS

```bash
# 推荐: 使用 Homebrew tap（更新最及时）
brew install anomalyco/tap/opencode

# 或者使用安装脚本
curl -fsSL https://opencode.ai/install | bash

# 或者使用 npm
npm install -g opencode-ai
```

### Linux

```bash
# 安装脚本（自动检测架构）
curl -fsSL https://opencode.ai/install | bash

# Arch Linux
sudo pacman -S opencode

# 或者 AUR 最新版
paru -S opencode-bin
```

### Windows (WSL 推荐)

```bash
# 使用 WSL 获得最佳体验
# 在 WSL 中执行:
curl -fsSL https://opencode.ai/install | bash

# 或者 Chocolatey
choco install opencode

# 或者 Scoop
scoop install opencode
```

### Docker

```bash
docker run -it --rm ghcr.io/anomalyco/opencode
```

### 验证安装

```bash
opencode --version
```

---

## 2. 配置模型提供商

### 使用 OpenCode Zen（推荐新手）

```bash
# 在 TUI 中运行
/connect
# 选择 opencode，前往 https://opencode.ai/auth 获取 API Key
```

### 配置其他提供商

| 提供商 | 配置方式 |
|--------|----------|
| **OpenAI** | 设置 `OPENAI_API_KEY` 环境变量 |
| **Anthropic Claude** | 设置 `ANTHROPIC_API_KEY` 环境变量 |
| **OpenRouter** | 设置 `OPENROUTER_API_KEY` 环境变量 |
| **GitHub Copilot** | TUI 中 `/connect` 选择 GitHub 登录 |
| **Google Gemini** | 设置 `GEMINI_API_KEY` 环境变量 |
| **本地模型** | 通过 Ollama 等本地服务 |

在 TUI 中使用 `/connect` 命令可以交互式选择并配置提供商。

---

## 3. 启动与初始化

### 启动 TUI

```bash
# 在当前目录启动
opencode

# 指定项目目录
opencode /path/to/project

# 继续上次会话
opencode --continue
```

### 初始化项目

首次进入项目，运行 `/init` 命令：

```
/init
```

这会自动分析项目结构并生成 `AGENTS.md` 文件，让 OpenCode 了解项目的编码规范、框架和模式。

> 建议将 `AGENTS.md` 提交到 Git 仓库。

---

## 4. TUI 界面操作

### 基本对话

```
Give me a quick summary of the codebase.
```

### 引用文件

使用 `@` 模糊搜索项目中的文件并引用到对话中：

```
How is auth handled in @src/auth/index.ts
```

### 执行 Shell 命令

以 `!` 开头直接执行 shell 命令：

```
!ls -la
!git status
```

### 拖放图片

将图片拖入终端，OpenCode 会自动将其添加到对话上下文中。

### Plan 模式 vs Build 模式

按 **Tab** 键切换：

- **Plan 模式** — AI 只给出实施计划，不修改代码
- **Build 模式** — AI 直接执行代码修改

建议先让 AI 出计划，确认后再切换 Build 模式执行。

---

## 5. 斜杠命令

在 TUI 中输入 `/` 可触发以下命令：

| 命令 | 别名 | 快捷键 | 作用 |
|------|------|--------|------|
| `/connect` | — | — | 配置模型提供商 |
| `/init` | — | — | 初始化项目 AGENTS.md |
| `/undo` | — | `Ctrl+X u` | 撤销上次修改 |
| `/redo` | — | `Ctrl+X r` | 重做撤销 |
| `/new` | `/clear` | `Ctrl+X n` | 新建会话 |
| `/compact` | `/summarize` | `Ctrl+X c` | 压缩会话（减少 token 消耗） |
| `/models` | — | `Ctrl+X m` | 查看可用模型 |
| `/themes` | — | `Ctrl+X t` | 切换主题 |
| `/editor` | — | `Ctrl+X e` | 打开外部编辑器写消息 |
| `/export` | — | `Ctrl+X x` | 导出会话为 markdown |
| `/share` | — | — | 生成分享链接 |
| `/unshare` | — | — | 取消分享 |
| `/exit` | `/quit` `/q` | `Ctrl+X q` | 退出 |
| `/help` | — | — | 显示帮助 |
| `/details` | — | — | 切换工具执行详情 |
| `/sessions` | — | — | 查看会话列表 |

---

## 6. 快捷键

> 默认 Leader 键为 `Ctrl+X`

| 快捷键 | 作用 |
|--------|------|
| `Ctrl+X n` | 新建会话 |
| `Ctrl+X u` | 撤销 |
| `Ctrl+X r` | 重做 |
| `Ctrl+X c` | 压缩会话 |
| `Ctrl+X m` | 选择模型 |
| `Ctrl+X t` | 切换主题 |
| `Ctrl+X e` | 打开编辑器 |
| `Ctrl+X x` | 导出会话 |
| `Ctrl+X q` | 退出 |
| `Ctrl+L` | 清屏 |
| `Tab` | 切换 Plan / Build 模式 |
| `@` | 引用文件 |
| `!` | Shell 命令前缀 |
| `↑`/`↓` | 历史消息导航 |

---

## 7. CLI 命令行模式

OpenCode 也支持非交互式的 CLI 模式，适合脚本和自动化。

### 基础用法

```bash
# 一次问答
opencode run "解释 JavaScript 中闭包的工作原理"

# 指定模型
opencode run -m anthropic/claude-sonnet-4-5 "分析这段代码的性能问题"

# 带文件上下文
opencode run "重构 @src/utils.ts 中的函数"
```

### CLI 子命令

| 命令 | 作用 |
|------|------|
| `opencode run <prompt>` | 执行一次问答 |
| `opencode [project]` | 启动 TUI |
| `opencode session list` | 列出会话 |
| `opencode session show <id>` | 查看会话详情 |
| `opencode attach` | 附加到已有会话 |
| `opencode auth` | 管理认证 |
| `opencode models` | 列出可用模型 |
| `opencode mcp` | 管理 MCP 服务器 |
| `opencode web` | 启动 Web 界面 |
| `opencode serve` | 启动 API 服务 |
| `opencode upgrade` | 升级 OpenCode |
| `opencode uninstall` | 卸载 |

### 全局标志

| 标志 | 简写 | 作用 |
|------|------|------|
| `--model` | `-m` | 指定模型 |
| `--agent` | — | 指定 agent |
| `--continue` | `-c` | 继续上次会话 |
| `--session` | `-s` | 指定会话 ID |
| `--prompt` | — | 启动时自动发送提示词 |
| `--port` | — | 监听端口 |
| `--hostname` | — | 监听地址 |

---

## 8. 配置文件

OpenCode 支持 JSON/JSONC 格式配置文件，多个位置的配置会合并。

### 配置位置（优先级由低到高）

| 位置 | 路径 | 用途 |
|------|------|------|
| 远程配置 | 项目 `.well-known/opencode` | 组织默认值 |
| 全局配置 | `~/.config/opencode/opencode.json` | 个人偏好 |
| 环境变量 | `OPENCODE_CONFIG` 指定路径 | 临时覆盖 |
| 项目配置 | 项目根目录 `opencode.json` | 项目特定 |
| 目录配置 | `.opencode/` 下 | agents/commands/plugins |
| 运行时 | `OPENCODE_CONFIG_CONTENT` | 最高优先级 |

### 配置示例

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openai/gpt-4o",
  "autoupdate": true,
  "server": {
    "port": 4096
  },
  "tui": {
    "theme": "tokyo-night"
  },
  "snapshot": true,
  "command": {
    "test": {
      "template": "Run the full test suite and report any failures.",
      "description": "Run tests"
    }
  }
}
```

### 关键配置项

| 配置项 | 作用 |
|--------|------|
| `model` | 默认模型 (provider/model) |
| `autoupdate` | 自动更新 |
| `server.port` | API 服务端口 |
| `tui.theme` | TUI 主题 |
| `snapshot` | 开启快照（自动 git 管理） |
| `command` | 自定义命令 |
| `keybind` | 自定义快捷键 |
| `agent` | 自定义 Agent |
| `formatter` | 代码格式化配置 |
| `lsp` | LSP 服务器配置 |
| `permissions` | 工具调用权限 |
| `mcpServers` | MCP 服务配置 |

---

## 9. 自定义命令

你可以创建自定义命令来执行重复性任务。

### 方式一：JSON 配置

```jsonc
{
  "command": {
    "lint": {
      "template": "Run the linter and fix any issues found.",
      "description": "Lint and fix code"
    },
    "component": {
      "template": "Create a new React component named $ARGUMENTS with TypeScript support.",
      "description": "Create a React component"
    }
  }
}
```

### 方式二：Markdown 文件

在 `~/.config/opencode/commands/` 或项目 `.opencode/commands/` 下创建 `.md` 文件：

```markdown
---
description: Run tests with coverage
agent: build
model: anthropic/claude-sonnet-4-5
---

Run the full test suite with coverage report.
Focus on any failures and suggest fixes.
```

文件名为命令名，例如 `test.md` → `/test`。

### 命令模板变量

| 变量 | 作用 |
|------|------|
| `$ARGUMENTS` | 命令参数 |
| `$ARGUMENTS1` | 第 1 个参数 |
| `$ARGUMENTS2` | 第 2 个参数 |

---

## 10. AGENTS.md 规则

`AGENTS.md` 是项目级指令文件，OpenCode 会读取它来了解项目规范。

### 创建方式

```
/init
```

自动分析项目结构生成。你也可以手动创建。

### 示例

```markdown
# Project Guidelines

## Tech Stack
- Python 3.12 + FastAPI
- PostgreSQL with SQLAlchemy
- Vue 3 + TypeScript frontend

## Conventions
- Use type hints for all Python functions
- Write tests for all API endpoints
- Follow PEP 8 style guide

## Commands
- Run tests: `pytest tests/`
- Lint: `ruff check .`
- Format: `ruff format .`
```

### 存放位置

- 全局: `~/.config/opencode/AGENTS.md`
- 项目: `{project_root}/AGENTS.md`
- 目录: `.opencode/rules/` 下的 markdown 文件

---

## 11. 常见问题

### Q: 需要申请哪些 API？

最少需要一个 LLM 提供商。推荐 OpenRouter（一个 key 用多种模型）或 OpenCode Zen（开箱即用）。

### Q: OpenCode 是否存储我的代码？

不会。OpenCode 不存储任何代码或会话数据，所有处理在本地完成。共享会话需要手动执行 `/share`。

### Q: 如何切换模型？

TUI 中按 `Ctrl+X m` 或 `/models` 选择模型。

### Q: 如何撤销 AI 做的修改？

`/undo` 可撤销最近一次修改（可多次撤销），`/redo` 恢复。

### Q: 支持哪些编辑器？

OpenCode 可通过以下方式使用：
- **终端 TUI** — 原生体验（推荐）
- **桌面 App** — Windows/macOS/Linux（Beta 版）
- **IDE 扩展** — 支持主流 IDE
- **Web 界面** — `opencode web`
- **CLI 命令行** — 脚本集成

### Q: 如何在 macOS 上管理 API Key？

推荐使用 macOS 钥匙串，在 `.zshenv` 中添加：

```bash
export OPENROUTER_API_KEY=$(security find-generic-password -w -s "service-name" 2>/dev/null)
```

### Q: 如何更新 OpenCode？

```bash
opencode upgrade
# 或者
brew upgrade opencode
```

---

> 更多信息请访问: https://opencode.ai/docs
> Discord 社区: https://opencode.ai/discord
> GitHub: https://github.com/anomalyco/opencode
