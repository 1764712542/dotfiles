# AI 开发环境速查手册

> MacBook Pro M2 · 16GB · macOS 26.5.1 · Zsh 5.9

---

## 一、Shell 环境

### 快速命令

| 命令 | 作用 |
|------|------|
| `ai` | 激活 Python AI 虚拟环境（`source ~/.venvs/ai/bin/activate`） |
| `v` / `vi` / `vim` | 启动 Neovim |
| `lg` | 启动 Lazygit |
| `bt` / `top` | 系统监控 (btop) |
| `h` | 历史搜索 (atuin) |
| `hg` | 交互式历史搜索 |
| `ports` | 查看端口占用 |
| `reload` | 重载 zsh 配置 |
| `t` | zellij 会话管理 |
| `just ...` | 任务执行器（见下文） |

### 文件导航

| 命令 | 作用 |
|------|------|
| `ls` (eza) | 彩色文件列表 |
| `ll` | 详细列表 + git 状态 |
| `lt` | 树形目录 |
| `cat` (bat) | 语法高亮查看文件 |
| `grep` (rg) | 高速搜索 |
| `diff` (delta) | 语法高亮 diff |
| `z <dir>` | zoxide 快速跳转 |
| `zi` | 交互式跳转 |
| `Ctrl+T` | fzf 搜索文件 |
| `Alt+C` | fzf 搜索目录 |
| `Ctrl+R` | fzf 搜索历史 |

### 包管理

| 命令 | 作用 |
|------|------|
| `brewup` | brew 更新 + 升级 + 清理 |
| `brewcask` | 安装 GUI 应用 |
| `brew leaves` | 列出显式安装的公式 |
| `mise install` | 安装运行环境 (Python/Node) |
| `mise ls` | 查看已安装版本 |

### 网络

| 命令 | 作用 |
|------|------|
| `myip` | 查看公网 IP |
| `localip` | 查看本机 IP |
| `ping` | ping（默认 5 次） |
| ClashX: `7892` | 代理端口（HTTP + SOCKS5） |

---

## 二、AI 开发环境

### 激活

```sh
ai   # 激活 ~/.venvs/ai (Python 3.12)
# 之后可使用所有 AI 包
```

### Python AI 栈

```
路径:   ~/.venvs/ai
Python: 3.12.13 (mise 管理)
包管理: uv
```

| 包 | 版本 | 用途 |
|----|------|------|
| torch | 2.12.1 | 深度学习 (MPS 加速 ✅) |
| torchvision | 0.27.1 | 计算机视觉 |
| torchaudio | 2.11.0 | 音频处理 |
| transformers | 5.12.1 | HuggingFace 模型 |
| datasets | 5.0.0 | HuggingFace 数据集 |
| accelerate | 1.14.0 | 分布式训练 |
| jupyterlab | 4.5.0 | 交互式笔记本 |
| huggingface-hub | 1.20.1 | 模型下载 (`hf` CLI) |

### 验证

```sh
uv run --python ~/.venvs/ai python3 -c "
import torch
print(f'PyTorch {torch.__version__}, MPS: {torch.backends.mps.is_available()}')
"
```

### 添加新包

```sh
uv pip install <package> --python ~/.venvs/ai
```

---

## 三、本地模型

### Ollama（本机 GPU 推理）

```
状态: 自启动 (launch agent), 端口 11434
```

```sh
ollama list                      # 查看已下载模型
ollama pull <model>              # 下载新模型
ollama rm <model>                # 删除模型
ollama run qwen3:8b              # 交互式对话
curl http://localhost:11434/api/generate -d '{
  "model": "qwen3:8b",
  "prompt": "你好",
  "stream": false
}'
```

已安装模型:

| 模型 | 大小 | 用途 |
|------|------|------|
| `qwen3:8b` | 5.2 GB | 通用对话 / 代码 / 思维链推理 |
| `nomic-embed-text` | 274 MB | 文本嵌入 (RAG) |

### LM Studio

```sh
open /Applications/LM\ Studio.app
# 或用: brew open lm-studio
```

- 加载模型后，开启 **Developer Mode** → 在 `localhost:1234` 提供 API

---

## 四、Docker AI 服务

### 前置

```sh
colima start                               # 启动 Docker 运行时
```

### 启动全部服务

```sh
docker-compose -f ~/dotfiles/docker/docker-compose-ai.yml up -d
```

### 服务列表

| 服务 | 端口 | 用途 | Docker |
|------|------|------|--------|
| ChromaDB | `8000` | 向量数据库 (RAG) | ✅ |
| Qdrant | `6333` / `6334` | 向量数据库 (备选) | ✅ |
| pgvector | `5432` | PostgreSQL + 向量扩展 | ✅ |
| LiteLLM | `4000` | 统一 API 代理 | ✅ |

### LiteLLM（统一 API 入口）

所有客户端只需连 `http://localhost:4000`，兼容 OpenAI SDK。

配置: `~/dotfiles/docker/litellm_config.yaml`

| 模型名 | 实际后端 | 用途 |
|--------|----------|------|
| `qwen-local` | Ollama 本机 (qwen3:8b) | 本地推理 |
| `embed-local` | Ollama 本机 (nomic-embed-text) | 文本嵌入 |
| `gpt-4o-mini` | OpenRouter 云端 | 轻量云端 |
| `deepseek-chat` | OpenRouter 云端 | 强模型云端 |

```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:4000/v1", api_key="sk-none")
# 使用本地模型
resp = client.chat.completions.create(
    model="qwen-local",
    messages=[{"role": "user", "content": "你好"}]
)
```

### 日常维护

```sh
docker-compose -f ~/dotfiles/docker/docker-compose-ai.yml down   # 停止
docker-compose -f ~/dotfiles/docker/docker-compose-ai.yml logs   # 查看日志
docker-compose -f ~/dotfiles/docker/docker-compose-ai.yml pull   # 更新镜像
```

---

## 五、Neovim AI 编程

### AI 插件 (avante.nvim)

后端: OpenRouter API (`OPENROUTER_API_KEY` 从 macOS Keychain 加载)

| 快捷键 | 作用 |
|--------|------|
| `<leader>aa` | 打开 Avante 对话 |
| `<leader>am` | 选择模型 |
| `<leader>at` | 切换侧边栏 |
| `<leader>as` | 切换 fast / strong 模型 |
| `<leader>ae` | (Visual) 编辑选中代码 |
| `<C-y>` | 接受内联补全建议 |
| `<M-]>` | 下一个补全建议 |
| `<M-[>` | 上一个补全建议 |
| `<C-]>` | 拒绝补全建议 |

模型配置 (`~/.config/nvim/lua/plugins/ai.lua`):

- `fast` / `strong`: `openrouter/owl-alpha` (目前相同，可分别配置)

### 通用快捷键

| 快捷键 | 作用 |
|--------|------|
| `<C-p>` | 命令面板 (snacks.picker) |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全文搜索 |
| `<leader>fr` | 恢复上次搜索 |
| `<leader>f.` | 最近文件 |
| `<leader>n` | 文件树 |
| `<leader>r` | 运行当前文件 |
| `<C-h/j/k/l>` | 窗口导航 |
| `<leader>h` | 清除搜索高亮 |
| `<leader>q` | 退出 |
| `<C-s>` | 保存 |
| `<A-d>` | 浮动终端 |
| `jk` / `kj` | 退出插入模式 |
| `<A-f>` | 切换自动格式化 |
| `<A-S-f>` | 手动格式化 |

### Git

| 快捷键 | 作用 |
|--------|------|
| `gs` | git status |
| `gcm` | git commit -m |
| `gp` | git push |
| `gpl` | git pull |
| `glog` | 图形化 log |
| `lg` | Lazygit TUI |

### 调试

| 快捷键 | 作用 |
|--------|------|
| `<F6>` / `<leader>dc` | 继续 |
| `<F8>` / `<leader>db` | 断点切换 |
| `<F9>` / `<leader>di` | 步入 |
| `<F10>` / `<leader>do` | 步过 |
| `<leader>dr` | 调试界面 |

---

## 六、Justfile 任务

```sh
just activate      # 激活 AI 环境 (同上 ai 别名)
just jupyter       # 启动 JupyterLab
just ollama        # colima start + ollama serve
just chroma        # 启动 ChromaDB (独立 Docker)
just lmstudio      # 打开 LM Studio
just doctor        # 检查环境状态
just update        # 升级 AI Python 包
just freeze        # 冻结 requirements.txt
just update-all    # 升级 brew + mise + uv tools
just clean         # 清理 brew/mise/docker 垃圾
just gpu           # GPU 监控 (asitop)
just fix           # 格式化代码
just lint          # 代码检查
```

---

## 七、RAG 搭建指南

### 快速原型 (Python)

```python
# source ai 后运行
from langchain_community.embeddings import OllamaEmbeddings
from langchain_chroma import Chroma
from langchain_text_splitters import RecursiveCharacterTextSplitter

embeddings = OllamaEmbeddings(model="nomic-embed-text", base_url="http://localhost:11434")
vectorstore = Chroma(embedding_function=embeddings, persist_directory="./chroma_db")

texts = ["你的文档内容..."]
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
vectorstore.add_documents(splitter.create_documents(texts))

retriever = vectorstore.as_retriever()
# retriever.invoke("你的问题")
```

### Dify 部署（单独）

```sh
git clone https://github.com/langgenius/dify.git ~/dev/dify
cd ~/dev/dify/docker
docker-compose up -d
# 访问 http://localhost:3000
# 模型 provider 配置: http://host.docker.internal:4000 (LiteLLM)
```

---

## 八、镜像源（中国大陆）

| 工具 | 镜像源 |
|------|--------|
| Homebrew | USTC (`mirrors.ustc.edu.cn`) |
| Python pip | 清华 (`pypi.tuna.tsinghua.edu.cn`) |
| npm | 阿里 (`npmmirror.com`) |


---

## 九、环境变量

| 变量 | 来源 | 用途 |
|------|------|------|
| `OPENROUTER_API_KEY` | macOS Keychain | OpenRouter API |
| `HTTPS_PROXY` | `http://127.0.0.1:7892` | ClashX 代理 |
| `ALL_PROXY` | `socks5h://127.0.0.1:7892` | SOCKS5 代理 |
| `GOPATH` | `~/go` | Go 开发 |
| `EDITOR` | `nvim` | 默认编辑器 |

---

## 十、目录结构

```
~/
├── .venvs/ai/              ← Python AI 环境 (uv)
├── dotfiles/               ← 配置仓库 (GNU Stow)
│   ├── zsh/                ← .zshenv / .zprofile / .zshrc
│   ├── git/                ← .gitconfig
│   ├── nvim/               ← Neovim 配置
│   ├── docker/             ← docker-compose-ai.yml + litellm_config.yaml
│   ├── brew/               ← .Brewfile
│   ├── zim/                ← .zimrc
│   ├── p10k/               ← .p10k.zsh
│   ├── mise/               ← config.toml (运行时管理)
│   ├── npm/                ← .npmrc
│   ├── pip/                ← pip.conf
│   └── justfile            ← 任务定义
├── .config/
│   └── nvim/               ← 实际 Neovim 配置 (stow 链接)
└── dev/
    └── dify/               ← Dify (可选 RAG 平台)
```
