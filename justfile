# ── AI 开发任务 ──

# 激活 AI 环境
activate:
    source ~/venvs/ai/bin/activate

# 启动 Jupyter Lab
jupyter: activate
    jupyter lab --no-browser

# 启动 Ollama (需先 colima start)
ollama:
    colima start && ollama serve

# 启动 ChromaDB
chroma:
    docker run --rm -p 8000:8000 chromadb/chroma:latest

# 启动 LM Studio API 模式 (需 LM Studio 已打开)
lmstudio:
    open /Applications/LM\ Studio.app
    @echo "→ 在 LM Studio 中启用 Developer Mode 以开启 API 服务"

# ── 环境维护 ──

# 更新 AI 环境依赖
update: activate
    uv pip install --upgrade openai anthropic langchain llama-index mlx mlx-lm transformers torch chromadb

# 冻结依赖
freeze: activate
    uv pip freeze > requirements.txt
    @echo "✓ requirements.txt 已更新"

# 检查 GPU 状态
gpu:
    asitop

# ── 系统状态 ──

# 查看 macOS 神经网络引擎 / GPU 使用
ane:
    sudo dmesg | grep -i "ane\|neural" | tail -10 || echo "无 ANE 信息"
