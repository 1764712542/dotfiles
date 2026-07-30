#!/usr/bin/env bash
set -euo pipefail

echo "=== 规则文件行数检查 (≤50 行) ==="
wc -l global/*.md enterprise/*.md personal/*.md opencode/*.md INDEX.md | sort -rn | head -20

echo ""
echo "=== paths 冲突检查 ==="
grep -r "^paths:" --include="*.md" global/ enterprise/ personal/ opencode/ | \
  sed 's/.*paths: *//' | sort | uniq -c | sort -rn | head -20

echo ""
echo "=== 重复规则扫描 (关键词) ==="
for kw in "SAFETY" "Workflow" "Git" "Verify" "Communication" "Token" "Code Style" "命名" "测试" "验证"; do
  count=$(grep -r "$kw" --include="*.md" global/ enterprise/ personal/ opencode/ | wc -l)
  if [ "$count" -gt 3 ]; then
    echo "⚠️  '$kw' 出现 $count 次, 可能重复"
  fi
done

echo ""
echo "=== 完成 ==="