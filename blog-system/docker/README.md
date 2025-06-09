# Docker 部署说明

本目录包含了博客系统的 Docker 部署相关文件。

## 文件结构

```
docker/
├── docker-compose.yml      # Docker Compose 配置文件
├── Dockerfile.backend       # 后端服务 Dockerfile
├── docker-start.bat        # Windows 启动脚本
├── frontend/               # 前端相关文件
│   ├── Dockerfile          # 前端服务 Dockerfile
│   └── nginx.conf          # Nginx 配置文件
└── README.md               # 本说明文件
```

## 快速开始

### 方法一：使用启动脚本（推荐）

1. 在当前目录运行启动脚本：
   ```bash
   # Windows
   docker-start.bat
   ```

2. 选择相应的选项：
   - `1` - 启动所有服务（完整堆栈）
   - `2` - 仅启动数据库
   - `3` - 启动后端服务
   - `4` - 启动前端服务
   - `5` - 构建所有镜像
   - `6` - 查看服务状态
   - `7` - 查看日志
   - `8` - 停止所有服务
   - `9` - 清理 Docker 资源

### 方法二：使用 Docker Compose 命令

1. 启动所有服务：
   ```bash
   docker-compose up -d
   ```

2. 查看服务状态：
   ```bash
   docker-compose ps
   ```

3. 查看日志：
   ```bash
   docker-compose logs -f
   ```

4. 停止服务：
   ```bash
   docker-compose down
   ```

## 服务访问地址

- **前端应用**: http://localhost:3000
- **后端API**: http://localhost:8080
- **数据库**: localhost:3306
- **Redis缓存**: localhost:6379（可选）
- **Nginx代理**: localhost:80（可选）

## 环境变量配置

主要的环境变量在 `docker-compose.yml` 中已经配置好：

- `SPRING_PROFILES_ACTIVE=docker` - 使用 Docker 环境配置
- `MYSQL_ROOT_PASSWORD=123456` - MySQL root 密码
- `MYSQL_DATABASE=blog_system` - 数据库名称

## 数据持久化

- MySQL 数据存储在 Docker volume `mysql_data` 中
- 上传文件、日志等通过 volume 映射到宿主机

## 故障排除

### 常见问题

1. **端口冲突**：
   - 确保端口 3000、8080、3306 未被占用
   - 可以修改 `docker-compose.yml` 中的端口映射

2. **构建失败**：
   - 检查 Docker 是否正常运行
   - 确保网络连接正常（需要下载依赖）

3. **数据库连接失败**：
   - 等待 MySQL 服务完全启动（约 30-60 秒）
   - 检查数据库初始化脚本是否正确执行

### 查看详细日志

```bash
# 查看特定服务日志
docker-compose logs -f blog-backend
docker-compose logs -f mysql
docker-compose logs -f blog-frontend

# 查看所有服务日志
docker-compose logs -f
```

### 重新构建镜像

```bash
# 重新构建所有镜像
docker-compose build --no-cache

# 重新构建特定服务
docker-compose build --no-cache blog-backend
```

## 生产环境注意事项

1. **安全配置**：
   - 修改默认密码
   - 配置 HTTPS
   - 设置防火墙规则

2. **性能优化**：
   - 调整 JVM 参数
   - 配置数据库连接池
   - 启用 Redis 缓存

3. **监控和日志**：
   - 配置日志收集
   - 设置健康检查
   - 监控资源使用情况

更多详细信息请参考项目根目录的 `DEPLOYMENT.md` 文件。