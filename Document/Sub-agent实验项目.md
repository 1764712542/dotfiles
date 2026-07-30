# Sub-agent实验项目

-------------------

## 项目说明:

当前环境

```shell
❯ pwd
/Users/zhuyao/projects/ecommerce-demo
❯ ls
 cmd   internal   pkg   go.mod   go.sum
```

![image-20260708194459925](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708194459925.png)

因学习原因, 这次采用GoLang语言进行开发,并且采用hermes agent进行并发sub-agent

因为hermes agent其桌面端能够更加明确的了解以及查看自agent(子代理)

![image-20260708211458529](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708211458529.png)

## 第一步:统一规则claude .md

```shell
a/projects/markdown-tool/.claude/CLAUDE.md → b/projects/markdown-tool/.claude/CLAUDE.md
@@ -0,0 +1,10 @@
+# Markdown 笔记工具
+
+## 结构
+- cmd/main.go — CLI 入口
+- internal/converter/ — Markdown 转 HTML
+- internal/stats/ — 笔记统计分析
+- pkg/ — 共享工具
+
+## 目标
+实现 Markdown 笔记的格式转换和统计分析
```

## 第二步:配置开发工程师(writer)

```markdown
a/projects/markdown-tool/.claude/agents/writer.md → b/projects/markdown-tool/.claude/agents/writer.md
@@ -0,0 +1,12 @@
+---
+name: writer
+description: 实现工程师 — 编写核心功能代码
+---
+
+你是一位资深 Go 开发工程师。你的任务是实现 Markdown 笔记转换器的核心逻辑。
+
+要求：
+- 在 internal/converter/ 下实现 Markdown 到 HTML 的转换
+- 支持标题、段落、列表、代码块、引用、链接
+- 代码要干净，有文档注释
+- 错误处理要完善
```

## 第三步:配置测试agent(tester)

```markdown
a/projects/markdown-tool/.claude/agents/tester.md → b/projects/markdown-tool/.claude/agents/tester.md
@@ -0,0 +1,13 @@
+---
+name: tester
+description: 测试工程师 — 编写全面的测试用例
+---
+
+你是一位资深 Go 测试工程师。你的任务是为核心功能编写测试。
+
+要求：
+- 为 internal/converter/ 编写单元测试
+- 测试边界情况（空输入、特殊字符、非法 Markdown）
+- 使用表格驱动测试
+- 覆盖率目标：核心函数 80%+
+- 编写 Benchmark 测试
```

## 第三步:配置审核reveriewer

```
a/projects/markdown-tool/.claude/agents/reviewer.md → b/projects/markdown-tool/.claude/agents/reviewer.md
@@ -0,0 +1,18 @@
+---
+name: reviewer
+description: 代码审查员 — 审查代码质量和安全性
+---
+
+你是一位 Go 代码质量审查员。你的任务是审查项目代码。
+
+检查项：
+1. 代码结构是否合理
+2. 错误处理是否完善
+3. 是否有安全漏洞
+4. Go 惯用法是否正确
+5. 测试是否充分
+
+输出格式：
+- 列出问题，标注严重程度（高/中/低）
+- 给出改进建议
+- 不要修改代码，只报告
```

![image-20260708211951612](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708211951612.png)

![image-20260708212018260](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708212018260.png)

## 观察:

如下图,我们可以看到几个子agent再各自执行各自的人物,互不干扰,专注“自己”的事情

![image-20260708212210225](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708212210225.png)

![image-20260708213229112](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708213229112.png)

我们也可以看到,当一个完成之后,其他的还在并行继续, 比较只有写完了代码才能进行测试

![image-20260708213446291](/Users/zhuyao/Library/Application Support/typora-user-images/image-20260708213446291.png)

当一个测试挂掉的时候, tester 会根据之前的编排等待,最后一起测试修复

