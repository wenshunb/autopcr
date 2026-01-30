# Docker 安装与运行指南（含 override）

本文档说明如何在本项目中使用 Docker / Docker Compose 运行服务，并通过 `docker-compose.override.yml` 保留本地配置。

## 1. 前置条件

- 已安装 Docker（推荐 Docker Desktop）
- 已安装 Docker Compose（Docker Desktop 自带）

> 校验命令：
>
> - `docker --version`
> - `docker compose version`

## 2. 准备环境变量（可选）

项目提供了默认值，不配置也能运行。若需要自定义端口或管理员 QQ，可创建 `.env`：

```bash
cp .env.example .env
```

`.env` 示例：

```
AUTOPCR_SERVER_PORT=13200
AUTOPCR_SERVER_DEBUG_LOG=false
AUTOPCR_SERVER_ALLOW_REGISTER=true
# AUTOPCR_SERVER_SUPERUSER=123456789
```

> `.env` 已在 `.gitignore` 中忽略，不会被提交。

## 3. 启动服务（基础版）

使用仓库自带的 `docker-compose.yml`：

```bash
docker compose up --build
```

默认会映射端口 `13200`，访问：

```
http://localhost:13200
```

## 4. 使用 docker-compose.override.yml（本地定制）

如果你想把数据目录绑定到宿主机、或修改端口等，请创建 `docker-compose.override.yml`：

```yaml
services:
  autopcr:
    ports:
      - "18000:13200"
    volumes:
      - ./data:/app/data
      - ./cache:/app/cache
      - ./result:/app/result
      - ./log:/app/log
```

说明：

- `docker-compose.override.yml` 只影响本机，不会提交到仓库（已加入 `.gitignore`）
- 上面的示例把容器内的 `/app/data` `/app/cache` `/app/result` `/app/log` 映射到当前目录，方便持久化与查看

启动时无需额外指定：

```bash
docker compose up --build
```

Docker Compose 会自动加载 `docker-compose.override.yml`。

## 5. 停止与清理

停止服务：

```bash
docker compose down
```

删除容器与匿名卷：

```bash
docker compose down -v
```

> 如果你使用了本地 bind mount（override 方式），数据会保留在宿主机路径。

## 6. 常见问题

**Q: 端口冲突怎么办？**

A: 在 `.env` 中修改 `AUTOPCR_SERVER_PORT`，或在 `docker-compose.override.yml` 的 `ports` 中改宿主机端口。

**Q: 需要提交 `docker-compose.override.yml` 吗？**

A: 不需要，建议保持本地化，避免冲突。

**Q: 为什么要把 /app/data 也挂载？**

A: 项目会把账号信息等持久化到 `/app/data`，不挂载会导致容器重建后丢失数据。
