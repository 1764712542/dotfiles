---
paths: ["**/frontend/**", "**/ui/**"]
---

# 前端开发

## 框架
- React / Vue / Svelte 按项目选, 不混用
- 状态: server state (TanStack Query) > context > zustand

## 组件
- 原子 → 分子 → 组织 → 页面 (atomic design)
- Props: interface + JSDoc
- 样式: CSS Modules / Tailwind, 不 global CSS
- 单一职责: 1 组件 ≤ 1 个功能

## 可访问性
- 语义标签: `<nav> <main> <button>` 替代 `<div>`
- 键盘导航: tabindex + onKeyDown
- ARIA: role + label + description
- 色彩: WCAG 2.1 AA (对比度 ≥ 4.5:1)

## 国际化
- 文本: i18n key, 不硬编码
- 日期/数字: `Intl.DateTimeFormat` / `Intl.NumberFormat`
- 支持 RTL

## 性能
- 首屏: < 1.5s (3G), < 0.8s (4G)
- LCP < 2.5s / FID < 100ms / CLS < 0.1
- 代码分割: 按路由懒加载
- 图片: WebP / AVIF + lazy loading + 响应式尺寸

## 构建 & 测试
- tree-shaking: named import, 不用 `import *`
- 资源: 图片/字体预加载 + 懒加载
- 组件: Testing Library (用户视角)
- E2E: Playwright / Cypress (关键流程)
