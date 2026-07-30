# Codex CLI 安装与使用教程

---

## 目录

1. [安装](#1-安装)
2. [登录认证](#2-登录认证)
3. [国内网络配置](#3-国内网络配置)
4. [配置文件](#4-配置文件)
5. [常用命令](#5-常用命令)
6. [斜杠命令](#6-斜杠命令)
7. [沙箱与权限](#7-沙箱与权限)
8. [项目配置](#8-项目配置)
9. [MCP 与 Skills](#9-mcp-与-skills)
10. [会话管理](#10-会话管理)
11. [最佳实践](#11-最佳实践)
12. [常见问题](#12-常见问题)

---

## 1. 安装

### 前置条件

| 要求 | 最低版本 | 推荐版本 |
|---|---|---|
| Node.js | v18+ | v22+ |
| npm | 内置于 Node | 最新版 |
| macOS | macOS 12+ | 最新 |
| Linux | Ubuntu 20.04+ / Debian 11+ | 最新 |

检查 Node.js：

```bash
node -v  # 应输出 v18+
npm -v
```

### 安装方式

#### 方式一：npm 全局安装（推荐）

```bash
npm install -g @openai/codex
codex --version
```

国内网络慢可先换源：

```bash
npm config set registry https://registry.npmmirror.com
npm install -g @openai/codex
```

#### 方式二：Homebrew 安装

```bash
brew install --cask codex
```

#### 方式三：一键脚本

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

#### 方式四：直接下载二进制

```bash
# macOS Apple Silicon
curl -L https://github.com/openai/codex/releases/download/rust-v0.131.0/codex-aarch64-apple-darwin.tar.gz | tar -xz
sudo mv codex /usr/local/bin/

# macOS Intel
curl -L https://github.com/openai/codex/releases/download/rust-v0.131.0/codex-x86_64-apple-darwin.tar.gz | tar -xz
sudo mv codex /usr/local/bin/
```

#### 方式五：Windows

推荐 WSL2 + Linux 安装方式。原生 Windows 可在 PowerShell 中运行：

```powershell
npm install -g @openai/codex
```

---

## 2. 登录认证

Codex 支持两种登录方式：

### 方式一：ChatGPT 订阅登录（推荐日常使用）

```bash
codex login
```

会打开浏览器引导你完成 OAuth 登录。登录后使用你的 ChatGPT 订阅额度（Plus/Pro/Business/Edu/Enterprise）。

**无浏览器环境（Headless）：**

```bash
# 设备码登录（Beta）
codex login --device-auth
# 按提示在另一台有浏览器的设备上打开链接并输入验证码
```

### 方式二：API Key 登录（推荐 CI/CD、自动化）

```bash
printenv OPENAI_API_KEY | codex login --with-api-key
```

使用 API Key 登录按用量计费，不支持 ChatGPT 订阅专属功能（如快速模式）。

### 认证凭据存储

登录后凭据缓存在 `~/.codex/auth.json`。CLI 和 VS Code 扩展共享同一份缓存。

---

## 3. 国内网络配置

### 方案一：配置代理（推荐有梯子的用户）

Codex CLI 遵循标准 HTTP 代理环境变量：

```bash
# 临时设置（当前终端有效）
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890

# 永久生效 - 写入 ~/.zshrc 或 ~/.bashrc
echo 'export HTTP_PROXY=http://127.0.0.1:7890' >> ~/.zshrc
echo 'export HTTPS_PROXY=http://127.0.0.1:7890' >> ~/.zshrc
source ~/.zshrc
```

**验证代理是否生效：**

```bash
curl -x http://127.0.0.1:7890 https://api.openai.com/v1/models
```

**Codex 桌面 App 代理：** 不走环境变量，需在系统设置中配置：
- macOS：系统设置 → 网络 → 详细信息 → 代理 → 勾选 HTTPS 代理，填 `127.0.0.1:7890`

### 方案二：API 中转（推荐无梯子的用户）

使用国内 OpenAI 兼容中转服务，修改 `~/.codex/config.toml`：

```toml
# 自定义 Provider
model_provider = "myproxy"
model = "gpt-5.4-mini-codex"

[model_providers.myproxy]
name = "My Proxy"
base_url = "https://your-proxy.example.com/v1"
env_key = "MY_PROXY_API_KEY"
wire_api = "responses"
```

注意：`model_provider` 的值必须和 `[model_providers.xxx]` 的段名**完全一致**（大小写敏感）。

### 方案三：使用第三方模型

Codex 支持任何兼容 OpenAI 协议的 API：

```toml
# DeepSeek
[model_providers.deepseek]
name = "DeepSeek"
base_url = "https://api.deepseek.com/v1"
env_key = "DEEPSEEK_API_KEY"
wire_api = "responses"

# Ollama 本地模型
[model_providers.local]
name = "Local Ollama"
base_url = "http://localhost:11434/v1"
env_key = "OLLAMA_API_KEY"
wire_api = "responses"
```

临时切换：

```bash
codex --provider deepseek --model deepseek-chat "写一段代码"
codex --provider local --model llama3.3 "写一段代码"
```

---

## 4. 配置文件

Codex 配置文件使用 TOML 格式，优先级从高到低：

| 层级 | 路径 | 说明 |
|---|---|---|
| 命令行参数 | `codex -c key=value` | 最高优先级，单次生效 |
| 项目级 | `.codex/config.toml` | 项目根目录，需信任项目才加载 |
| Profile | `~/.codex/<name>.config.toml` | 多套配置，`-p <name>` 切换 |
| 用户级 | `~/.codex/config.toml` | 个人默认设置 |
| 系统级 | `/etc/codex/config.toml` | 管理员部署 |

### 用户级配置示例 `~/.codex/config.toml`

```toml
# 当前使用的模型
model = "openai/gpt-5.4-mini-codex"

# 当前使用的 Provider
model_provider = "openai"

# 推理强度：minimal | low | medium | high | xhigh
model_reasoning_effort = "medium"

# 上下文窗口（token 数）
model_context_window = 200000

# 沙箱模式：read-only | workspace-write | danger-full-access
sandbox_mode = "workspace-write"

# 审批策略：on-request（默认）| untrusted | never
approval_policy = "on-request"

# 网络搜索：cached（默认）| live | disabled
web_search = "cached"

# ─── 自定义 Provider ───
[model_providers.myproxy]
name = "My Proxy"
base_url = "https://your-proxy.example.com/v1"
env_key = "MY_PROXY_API_KEY"
wire_api = "responses"
```

### Profile 配置

创建多套配置方便切换：

```bash
# 创建 profile 文件
cp ~/.codex/config.toml ~/.codex/fast.config.toml
```

使用：

```bash
codex -p fast "快速完成任务"
```

---

## 5. 常用命令

### 交互式运行（TUI）

```bash
codex
```

启动全屏终端界面，可以对话式迭代。

### 直接执行（非交互）

```bash
codex "创建一个 Express.js 项目"
```

直接输出结果后退出，适合脚本和自动化。

### 指定模型运行

```bash
codex --model openai/gpt-5.1-codex-max "重构这个函数"
codex --model openai/gpt-5.4-mini-codex "写个 Hello World"
```

### 指定沙箱模式

```bash
# 只读分析（不修改任何文件）
codex --sandbox read-only "分析一下这个项目的架构"

# 完全访问（危险！仅限隔离环境）
codex --sandbox danger-full-access "运行构建脚本"
```

### 指定审批策略

```bash
# 从不询问（CI 场景）
codex --ask-for-approval never "运行测试"

# 不确定时询问（默认）
codex --ask-for-approval on-request "修改代码"
```

### 组合使用

```bash
codex --model openai/gpt-5.1-codex-max \
      --sandbox workspace-write \
      --ask-for-approval on-request \
      "修复 auth.ts 中的 Bug"
```

### 其他命令

| 命令 | 用途 |
|---|---|
| `codex exec` | 非交互执行（脚本化） |
| `codex resume` | 恢复上次会话 |
| `codex resume --last` | 直接恢复最近会话 |
| `codex fork` | 分叉当前对话到新线程 |
| `codex login` | 登录 |
| `codex logout` | 登出 |
| `codex mcp` | 管理 MCP 服务器 |
| `codex features` | 管理功能开关 |
| `codex sandbox` | 调试沙盒行为 |
| `codex --debug` | 开启调试日志 |

---

## 6. 斜杠命令

在 TUI 中输入 `/` 会弹出命令菜单。常用命令：

| 命令 | 用途 |
|---|---|
| `/model` | 切换当前模型和推理强度 |
| `/fast` | 切换快速模式 |
| `/permissions` | 更新审批策略 |
| `/approve` | 批准被拒绝的操作 |
| `/skills` | 浏览和使用技能 |
| `/status` | 查看当前会话状态和 token 用量 |
| `/new` | 开启新对话 |
| `/fork` | 分叉当前对话 |
| `/side` | 启动侧边会话 |
| `/compact` | 压缩上下文 |
| `/review` | 代码审查 |
| `/plan` | 规划模式 |
| `/goal` | 设置任务目标 |
| `/ps` | 查看后台终端 |
| `/copy` | 复制最近输出 |
| `/theme` | 切换主题 |
| `/keymap` | 自定义快捷键 |
| `/exit` | 退出会话 |

### 排队命令

Codex 运行时按 `Tab` 可以排队后续命令，Codex 会在当前轮次结束后执行。

---

## 7. 沙箱与权限

### 三层安全模型

Codex 的安全由**两层**独立控制：

1. **沙箱（Sandbox）**：技术上能访问什么
2. **审批（Approval）**：什么时候必须暂停请求许可

### 沙箱模式

| 模式 | 说明 | 适用场景 |
|---|---|---|
| `workspace-write`（默认） | 读写当前工作目录，出界需审批 | 日常开发 |
| `read-only` | 只看文件，不改不执行 | 代码分析 |
| `danger-full-access` | 无限制 | 隔离环境 |

### 审批策略

| 策略 | 说明 | 适用场景 |
|---|---|---|
| `on-request`（默认） | 可疑操作暂停确认 | 日常使用 |
| `untrusted` | 对未知命令要求确认 | 安全敏感 |
| `never` | 全自动 | CI/CD |

### 危险模式（仅隔离环境）

```bash
# 完全跳过审批和沙盒
codex --dangerously-bypass-approvals-and-sandbox
# 或简写
codex --yolo
```

**警告**：此模式仅适用于外部已隔离的环境（Docker、VM）。

---

## 8. 项目配置

### AGENTS.md（项目说明书）

在项目根目录创建 `AGENTS.md`，Codex 会自动读取：

```markdown
# Project AGENTS.md

## 项目简介
这是一个 React + TypeScript 电商前端项目。

## 开发命令
- `npm run dev` - 启动开发服务器
- `npm run build` - 生产构建
- `npm test` - 运行测试
- `npm run lint` - 代码检查

## 架构概览
- `src/components/` - UI 组件
- `src/pages/` - 页面路由
- `src/services/` - API 服务层

## 编码规范
- 使用函数式组件 + hooks
- 组件按 PascalCase 命名
- API 调用统一用 axios
- 禁止使用 `any` 类型

## 不要碰
- `.env.production` - 生产密钥
- `node_modules/` - 依赖目录
```

**多层 AGENTS.md**：Codex 从项目根目录一路读到当前工作目录，每层叠加。可以在子目录放更具体的指令：

```
AGENTS.md                    # 全局项目说明
src/AGENTS.md               # 源码目录规范
tests/AGENTS.md             # 测试目录规范
```

### 项目级 config.toml

在项目根目录创建 `.codex/config.toml`，覆盖用户级配置：

```toml
# .codex/config.toml
model = "openai/gpt-5.1-codex-max"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"

[features]
multi_agent = true
```

**注意**：项目级配置只有在你信任该项目后才会加载。首次打开项目时 Codex 会提示确认。

---

## 9. MCP 与 Skills

### MCP（Model Context Protocol）

连接外部工具和系统，如 GitHub、Linear、Figma 等：

```bash
# 添加 MCP 服务器
codex mcp add github \
  --command "npx" \
  --args "-y" "@modelcontextprotocol/server-github"
```

在 `~/.codex/config.toml` 中配置：

```toml
[[mcp.servers]]
name = "github"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]
```

### Skills（技能）

可复用的工作流脚本：

```bash
# 创建技能脚手架
$skill-creator
```

存放位置：
- 个人技能：`~/.agents/skills/`
- 项目技能：`.agents/skills/`

每个技能是一个 `SKILL.md` 文件，可附带 `scripts/` 和 `references/` 目录。

---

## 10. 会话管理

### 保存与恢复

```bash
# 恢复最近会话
codex resume

# 恢复指定会话
codex resume <session_id>

# 恢复所有会话（不限于当前目录）
codex resume --all

# 直接恢复最近会话
codex resume --last
```

会话文件存储在 `~/.codex/sessions/`。

### 会话内操作

| 操作 | 命令 | 说明 |
|---|---|---|
| 新开对话 | `/new` | 同一仓库切换新任务 |
| 分叉对话 | `/fork` | 保留历史，平行探索 |
| 压缩上下文 | `/compact` | 总结并压缩长对话 |
| 切换线程 | `/agent` | 在多 agent 线程间切换 |
| 查看状态 | `/status` | 模型、审批、token 用量 |

### 会话最佳实践

- 一条线程对应一个完整的工作单元
- 真正分叉时才 `/fork`
- 把有边界的任务（探索、测试、排查）交给 subagent
- 按任务拆线程，避免上下文劣化

---

## 11. 最佳实践

### 提示词四要素

一条好的提示词应包含：

1. **目标（Goal）**：要改什么、建什么？
2. **上下文（Context）**：相关文件、文件夹、报错——用 `@` 提及
3. **约束（Constraints）**：规范、架构、安全要求
4. **完成标准（Done when）**：什么算完成？"测试通过"、"bug 解决"

### 难任务先规划

```
/plan
```

让 Codex 先收集上下文、提澄清问题，再开始实现。

### 推理强度选择

| 任务复杂度 | 推理强度 |
|---|---|
| 小改动、简单查询 | `minimal` / `low` |
| 日常编码 | `medium` |
| 复杂重构 | `high` |
| 超长 agentic 工作 | `xhigh` |

### 验证工作流

1. 让 Codex 生成代码
2. 写或更新测试
3. 跑测试套件
4. 执行 lint 和格式化
5. `git diff` 审查改动
6. 确认后提交

### 常见误区

| 误区 | 正解 |
|---|---|
| 把持久规则塞进提示里 | 写进 `AGENTS.md` 或 skill |
| 对 agent 藏着构建/测试命令细节 | 明确告诉它怎么跑 |
| 多步任务跳过规划 | 先 `/plan` |
| 过早授予全部权限 | 从默认权限起步，收紧再放宽 |
| 多条活跃线程改同一批文件 | 用 git worktree 隔离 |
| 一个项目一条线程 | 按任务拆线程 |

---

## 12. 常见问题

### `command not found: codex`

安装目录未加入 PATH。检查：

```bash
which codex
echo $PATH
```

### 登录弹窗打不开

无浏览器环境用设备码登录：

```bash
codex login --device-auth
```

### 配置写了但不生效

1. 检查项目是否被标记为不可信
2. 检查 CLI 参数是否覆盖了 config.toml
3. 检查 `model_provider` 和 `[model_providers.xxx]` 段名是否一致

### 网络超时 / 连接失败

1. 确认代理环境变量已设置：`echo $HTTPS_PROXY`
2. 测试代理：`curl -x http://127.0.0.1:7890 https://api.openai.com/v1/models`
3. 公司内网可能需要导入企业 CA 证书：`export CODEX_CA_CERTIFICATE=/path/to/ca.pem`

### Codex 一直要求审批

修改 `~/.codex/config.toml`：

```toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"
```

或在命令行临时调整：

```bash
codex --ask-for-approval on-request "你的任务"
```

### 上下文太长，AI 开始遗忘

```
/compact
```

压缩当前会话上下文。

### 会话卡死

```
/clear
```

清空终端，重新开始。

### 网络访问被拒绝

`workspace-write` 模式下默认没有网络权限。开启：

```toml
# ~/.codex/config.toml
[sandbox_workspace_write]
network_access = true
```

或临时开启：

```bash
codex -c 'sandbox_workspace_write.network_access=true' "npm install"
```

### 调试模式

```bash
codex --debug "你的任务"
```

查看详细日志定位问题。

---

## 附录：完整配置模板

```toml
# ~/.codex/config.toml

# 基础设置
model = "openai/gpt-5.4-mini-codex"
model_provider = "openai"
model_context_window = 200000
model_reasoning_effort = "medium"

# 安全设置
sandbox_mode = "workspace-write"
approval_policy = "on-request"

# 功能开关
web_search = "cached"

# 自定义 Provider
[model_providers.myproxy]
name = "My Proxy"
base_url = "https://your-proxy.example.com/v1"
env_key = "MY_PROXY_API_KEY"
wire_api = "responses"

# 沙箱网络访问
[sandbox_workspace_write]
network_access = true
```
