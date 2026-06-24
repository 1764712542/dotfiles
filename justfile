# ── AI 开发 ──

activate:
    source ~/.venvs/ai/bin/activate

jupyter: activate
    jupyter lab --no-browser

ollama:
    colima start && ollama serve

chroma:
    docker run --rm -p 8000:8000 chromadb/chroma:latest

lmstudio:
    open /Applications/LM\ Studio.app
    @echo "→ 在 LM Studio 中启用 Developer Mode 以开启 API 服务"

# ── 代码格式化 ──

fix:
    @echo "── 格式化 Lua ──"
    @stylua lua/ 2>/dev/null || true
    @echo "── 格式化 Python ──"
    @ruff format . 2>/dev/null || true
    @echo "── 格式化 Go ──"
    @gofumpt -w . 2>/dev/null || true
    @echo "── 格式化 Shell ──"
    @shfmt -w -s . 2>/dev/null || true
    @echo "✓ 格式化完成"

lint:
    @echo "── Python ──"
    @ruff check . 2>/dev/null || true
    @echo "── Lua ──"
    @stylua --check lua/ 2>/dev/null || true
    @echo "── Go ──"
    @golangci-lint run ./... 2>/dev/null || true

# ── 环境维护 ──

update: activate
    uv pip install --upgrade openai anthropic langchain llama-index mlx mlx-lm transformers torch chromadb

freeze: activate
    uv pip freeze > requirements.txt
    @echo "✓ requirements.txt 已更新"

update-all:
    @echo "── Homebrew ──"
    brew update && brew upgrade && brew cleanup
    @echo "── mise ──"
    mise upgrade
    @echo "── uv tools ──"
    uv tool upgrade --all 2>/dev/null || true
    @echo "✓ 全部更新完成"

clean:
    @echo "── Homebrew ──"
    brew autoremove && brew cleanup --prune=30
    @echo "── mise ──"
    mise cache clear
    @echo "── Docker ──"
    docker system prune -af 2>/dev/null || true
    @echo "✓ 清理完成"

doctor:
    @echo "── 系统 ──"
    @sw_vers
    @echo "── Shell ──"
    @echo "$SHELL ($($SHELL --version 2>&1 | head -1))"
    @echo "── Node ──"
    @node -v 2>/dev/null || echo "(未安装)"
    @echo "── Python ──"
    @python3 --version 2>/dev/null || echo "(未安装)"
    @echo "── Go ──"
    @go version 2>/dev/null || echo "(未安装)"
    @echo "── Rust ──"
    @rustc --version 2>/dev/null || echo "(未安装)"
    @echo "── Neovim ──"
    @nvim --version 2>/dev/null | head -1 || echo "(未安装)"
    @echo "── mise ──"
    @mise ls 2>/dev/null
    @echo "── Docker ──"
    @docker --version 2>/dev/null || echo "(未安装)"
    @colima status 2>/dev/null || echo "colima: 未运行"

# ── 系统状态 ──

gpu:
    asitop

ane:
    sudo dmesg | grep -i "ane\|neural" | tail -10 || echo "无 ANE 信息"
