# ==========================================
# justfile — 任务编排（just）
# 部署路径: ~/dotfiles/justfile
# 所属包: root（非 stow 包）
# 功能: 格式化/lint/验证/更新/清理，just verify 是 commit 前必跑
# 使用: just [fix|lint|verify|doctor|update-all|clean]
# ==========================================

# ── AI 开发 ──

ollama:
    @if command -v ollama >/dev/null 2>&1; then pgrep -q ollama && echo "✓ ollama 已在运行" || (ollama serve &); else echo "✗ ollama 未安装" >&2; exit 1; fi

# ── 代码格式化 ──

fix:
    @echo "── 格式化 Lua ──"
    @if command -v stylua >/dev/null 2>&1; then stylua nvim/.config/nvim/lua/; else echo "SKIP: stylua 未安装"; fi
    @echo "── 格式化 Python ──"
    @if command -v ruff >/dev/null 2>&1; then ruff format .; else echo "SKIP: ruff 未安装"; fi
    @echo "── 格式化 Go ──"
    @if command -v gofumpt >/dev/null 2>&1; then gofumpt -w .; else echo "SKIP: gofumpt 未安装"; fi
    @echo "── 格式化 Shell ──"
    @if command -v shfmt >/dev/null 2>&1; then shfmt -w -s .; else echo "SKIP: shfmt 未安装"; fi
    @echo "✓ 格式化完成"

lint:
    @echo "── Python ──"
    @if ! command -v ruff >/dev/null 2>&1; then echo "SKIP: ruff 未安装"; elif RUFF_NO_CACHE=1 ruff check --show-files . 2>/dev/null | grep -q .; then RUFF_NO_CACHE=1 ruff check .; else echo "SKIP: 无 Python 文件"; fi
    @echo "── Lua ──"
    @if command -v stylua >/dev/null 2>&1; then stylua --check nvim/.config/nvim/lua/; else echo "SKIP: stylua 未安装"; fi
    @echo "── Go ──"
    @if ! find . -type f -name '*.go' -print -quit | grep -q .; then echo "SKIP: 无 Go 文件"; elif command -v golangci-lint >/dev/null 2>&1; then golangci-lint run ./...; else echo "SKIP: golangci-lint 未安装"; fi
    @echo "── zsh syntax ──"
    @if command -v zsh >/dev/null 2>&1; then zsh -n zsh/.zshenv zsh/.zprofile zsh/.zshrc && echo "✓ zsh entry files OK"; else echo "SKIP: zsh 未安装"; fi
    @if command -v zsh >/dev/null 2>&1; then for f in zsh/.zsh/*.zsh; do zsh -n "$f" || exit $$?; echo "✓ $f OK"; done; else echo "SKIP: zsh 未安装"; fi
    @echo "── bash syntax ──"
    @if command -v bash >/dev/null 2>&1; then bash -n configure && echo "✓ configure OK"; else echo "SKIP: bash 未安装"; fi

# ── 环境维护 ──

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
    docker system prune 2>/dev/null || true
    @echo "✓ 清理完成"

# ── 深度缓存清理（释放磁盘空间）──

cache-clean:
    @echo "── Homebrew ──"
    brew cleanup --prune=all
    @echo "── npm ──"
    @npm cache clean --force 2>/dev/null || true
    @echo "── uv ──"
    @uv cache clean 2>/dev/null || true
    @echo "── pip ──"
    @pip cache purge 2>/dev/null || true
    @echo "── mise ──"
    @mise cache clear 2>/dev/null || true
    @echo "✓ 缓存已清理"

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
    @echo "── Neovim ──"
    @nvim --version 2>/dev/null | head -1 || echo "(未安装)"
    @echo "── mise ──"
    @mise ls 2>/dev/null
    @echo "── Docker ──"
    @docker --version 2>/dev/null || echo "(未安装)"
    @colima status 2>/dev/null || echo "colima: 未运行"

# ── 验证 ──

verify:
    @echo "── lint ──"
    @just lint
    @echo ""
    @echo "── dotfiles symlink ──"
    @./configure doctor
    @echo ""
    @echo "── Homebrew ──"
    @if command -v brew >/dev/null 2>&1; then HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file brew/.Brewfile; else echo "✗ brew 未安装" >&2; exit 1; fi
    @echo ""
    @echo "── mise ──"
    @if command -v mise >/dev/null 2>&1; then mise current; else echo "✗ mise 未安装" >&2; exit 1; fi
    @echo ""
    @echo "── Docker Compose ──"
    @if command -v docker >/dev/null 2>&1; then OPENROUTER_API_KEY=validation-only docker compose -f docker/docker-compose-ai.yml config --quiet; elif command -v docker-compose >/dev/null 2>&1; then OPENROUTER_API_KEY=validation-only docker-compose -f docker/docker-compose-ai.yml config --quiet; else echo "✗ Docker Compose 未安装" >&2; exit 1; fi
    @echo ""

# ── Git 工作流 ──

# 交互式提交（conventional commit 格式）
commit type msg:
    @if git diff --cached --quiet; then echo "✗ 请先显式暂存本次提交的文件" >&2; exit 1; fi
    git commit -m "{{type}}: {{msg}}"

alias c := commit

# 提交并推送（需预先显式暂存）
sync type msg:
    @if git diff --cached --quiet; then echo "✗ 请先显式暂存本次提交的文件" >&2; exit 1; fi
    git commit -m "{{type}}: {{msg}}"
    git push

# ── Pentest ──

# 将 pentest agents 从 Claude Code 同步到 Codex CLI
pentest-sync:
    python3 codex/scripts/convert-pentest-agents.py --force
    @echo "✓ 同步完成"

# 检查渗透工具链
pentest-doctor:
    @omni-pentest doctor

# 列出所有 pentest agents
pentest-agents:
    @omni-pentest agents

# 查看未提交变更概览
status:
    git status --short --branch
    @echo ""
    @echo "── 未暂存变更 ──"
    @git diff --stat
