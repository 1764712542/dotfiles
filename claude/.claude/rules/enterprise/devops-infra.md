---
paths: ["**/*.tf", "**/k8s/**", "**/helm/**", "**/docker-compose*", "**/Dockerfile*"]
---

# Kubernetes & Docker & Terraform

## Kubernetes
- 资源: 显式 requests + limits
- 探针: liveness + readiness + startup
- HPA: 基于 CPU / 自定义 metrics
- ConfigMap/Secret: 环境配置, 不硬编码

## Docker
- 镜像 < 500 MB
- 非 root 运行
- HEALTHCHECK 必写
- .dockerignore: node_modules / .git / .env

## Terraform
- state: 远程 backend (S3/GCS + DynamoDB lock)
- 资源: tags (project / env / owner)
- 模块化: 抽 common 模块
- plan 先 review 再 apply