# 博客系统部署指南

本文档详细介绍了博客系统的多种部署方式，包括本地开发环境、Docker容器化部署等。

## 目录

- [系统要求](#系统要求)
- [本地开发部署](#本地开发部署)
- [Docker容器化部署](#docker容器化部署)
- [生产环境部署](#生产环境部署)
- [常见问题](#常见问题)

## 系统要求

### 基础要求
- **操作系统**: Windows 10/11, macOS, Linux
- **Java**: JDK 17 或更高版本
- **Node.js**: 16.x 或更高版本
- **MySQL**: 8.0 或更高版本
- **Maven**: 3.6 或更高版本

### Docker部署要求
- **Docker**: 20.10 或更高版本
- **Docker Compose**: 2.0 或更高版本

## 本地开发部署

### 方式一：使用启动脚本（推荐）

1. **快速启动**
   ```bash
   # Windows
   启动点我.bat
   
   # 选择选项 1: Full Start (Database + Backend + Frontend)
   ```

2. **脚本功能**
   - 自动检查和启动MySQL服务
   - 构建后端项目
   - 启动后端服务
   - 安装前端依赖并启动前端服务
   - 提供数据库管理功能

### 方式二：手动启动

1. **数据库准备**
   ```bash
   # 启动MySQL服务
   net start mysql
   
   # 创建数据库
   mysql -u root -p
   CREATE DATABASE blog_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

2. **启动后端**
   ```bash
   # 构建项目
   mvn clean package -DskipTests
   
   # 启动后端
   java -jar target/blog-system-0.0.1-SNAPSHOT.jar
   ```

3. **启动前端**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

### 数据库初始化

使用提供的初始化脚本：
```bash
# Windows
scripts\init-database.bat
```

或手动执行SQL文件：
```bash
mysql -u root -p123456 blog_system < src/main/resources/schema.sql
mysql -u root -p123456 blog_system < src/main/resources/data.sql
```

## 📋 部署前检查清单

在开始部署前，请确认以下条件：

- [ ] Java 21 或更高版本已安装
- [ ] JAVA_HOME 环境变量已配置
- [ ] MySQL 8.0+ 数据库已安装并运行
- [ ] 数据库用户权限已正确配置
- [ ] 防火墙端口 8080, 8081 已开放
- [ ] 足够的磁盘空间（建议 ≥ 2GB）
- [ ] 系统内存 ≥ 2GB

## 方案一：Windows 服务部署（推荐）

### 前置条件

1. 已安装 Java 21 或更高版本
2. 已配置 JAVA_HOME 环境变量
3. 已安装 Maven
4. 下载 [NSSM](https://nssm.cc/download) 并将 `nssm.exe` 放在项目根目录

### 安装步骤

1. **以管理员身份运行安装脚本**

   ```cmd
   右键点击 install-service.bat -> "以管理员身份运行"
   ```

2. **验证服务安装**

   - 打开 Windows 服务管理器 (`services.msc`)
   - 查找 "Blog System Backend Service"
   - 确认服务状态为 "正在运行"

3. **管理服务**

   ```cmd
   # 使用管理脚本
   manage-service.bat

   # 或使用 NSSM 命令
   nssm start BlogSystemBackend
   nssm stop BlogSystemBackend
   nssm restart BlogSystemBackend
   ```

### 服务特性

- ✅ 开机自启动
- ✅ 自动重启（崩溃时）
- ✅ 日志轮转
- ✅ 后台运行
- ✅ Windows 服务管理器集成

## 方案二：生产模式运行

### 使用启动脚本

```cmd
# 双击运行或命令行执行
start-backend.bat
```

### 手动运行

```cmd
# 构建项目
mvn clean package -DskipTests

# 运行 JAR 文件
java -jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod target\blog-system-0.0.1-SNAPSHOT.jar
```

## 方案三：Docker 容器化部署（推荐用于云环境）

### 使用 Docker Compose

```yaml
# docker-compose.yml
version: '3.8'
services:
  blog-backend:
    build: .
    ports:
      - "8080:8080"
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/blog_system
    depends_on:
      - mysql
    volumes:
      - ./uploads:/app/uploads
      - ./logs:/app/logs
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: your_password
      MYSQL_DATABASE: blog_system
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped

volumes:
  mysql_data:
```

### 使用脚本部署

1. 进入Docker目录并运行启动脚本：
```bash
# Windows
cd docker
docker-start.bat

# Linux/Mac
cd docker
chmod +x docker-start.sh
./docker-start.sh
```

### 使用Docker Compose

1. 进入Docker目录：
```bash
cd docker
```

2. 构建并启动所有服务：
```bash
docker-compose up -d
```

3. 查看服务状态：
```bash
docker-compose ps
```

4. 查看日志：
```bash
docker-compose logs -f
```

5. 停止服务：
```bash
docker-compose down
```



## 配置文件说明

### 生产环境配置 (`application-prod.yml`)

- 优化的数据库连接池
- 生产级别的日志配置
- 性能调优参数
- 健康检查端点
- 文件上传配置和存储路径
- 静态资源访问配置



## 监控和维护

### 文件存储目录

部署时需要确保以下目录存在且有写入权限：

```bash
# 创建上传目录
mkdir uploads
mkdir uploads/avatars

# 设置权限（Linux/Unix）
chmod 755 uploads
chmod 755 uploads/avatars
```

**注意事项**：
- 头像文件存储在 `uploads/avatars/` 目录
- 确保应用有读写权限
- 定期清理无效的上传文件
- 建议设置文件大小限制（默认2MB）

### 日志查看

```cmd
# Windows 服务日志
type logs\service-stdout.log
type logs\service-stderr.log
type logs\blog-system.log


```

### 健康检查

- 应用健康检查：http://localhost:8081/actuator/health
- 应用信息：http://localhost:8081/actuator/info
- 应用指标：http://localhost:8081/actuator/metrics
- 监控文件存储空间使用情况

### 性能优化建议

1. **JVM 参数调优**

   ```
   -Xms512m -Xmx1024m
   -XX:+UseG1GC
   -XX:+UseStringDeduplication
   ```

2. **数据库连接池优化**

   - 最大连接数：20
   - 最小空闲连接：5
   - 连接超时：30 秒

3. **日志管理**
   - 日志文件大小限制：100MB
   - 保留历史：30 天
   - 自动轮转

## 故障排除

### 常见问题

1. **服务无法启动**

   - 检查 JAVA_HOME 环境变量
   - 确认端口 8080 未被占用
   - 查看服务日志文件

2. **数据库连接失败**

   - 确认 MySQL 服务运行
   - 检查数据库连接参数
   - 验证数据库用户权限

3. **内存不足**
   - 调整 JVM 堆内存参数
   - 监控系统资源使用

### 卸载服务

```cmd
# 使用管理脚本
manage-service.bat -> 选择选项 6

# 或使用 NSSM 命令
nssm stop BlogSystemBackend
nssm remove BlogSystemBackend confirm
```

## 📋 部署后验证清单

部署完成后，请按以下清单验证系统运行状态：

### 基础功能验证
- [ ] 后端服务正常启动（端口 8080）
- [ ] 管理端口可访问（端口 8081）
- [ ] 数据库连接正常
- [ ] 日志文件正常生成
- [ ] 文件上传目录可写入

### API 接口验证
- [ ] 健康检查：`GET http://localhost:8081/actuator/health`
- [ ] 用户注册：`POST http://localhost:8080/api/auth/register`
- [ ] 用户登录：`POST http://localhost:8080/api/auth/login`
- [ ] 文章列表：`GET http://localhost:8080/api/articles`

### 性能和监控验证
- [ ] 内存使用率 < 80%
- [ ] CPU 使用率 < 70%
- [ ] 响应时间 < 2 秒
- [ ] 日志轮转正常工作

## 🚀 推荐部署方案

| 环境类型 | 推荐方案 | 特点 |
|----------|----------|------|
| **小型生产环境** | Windows 服务部署 | 简单可靠，易于维护 |
| **云环境/容器化** | Docker 部署 | 可扩展，环境一致性 |
| **高可用环境** | 负载均衡 + 多实例 | 高可用，性能优异 |

## 🔧 运维建议

### 定期维护任务
- **每日**：检查服务状态、查看错误日志
- **每周**：清理过期日志、检查磁盘空间
- **每月**：数据库备份、性能分析
- **每季度**：安全更新、配置优化

### 监控告警
建议配置以下监控指标：
- 服务可用性（99.9% SLA）
- 响应时间（< 2 秒）
- 内存使用率（< 80%）
- 磁盘空间（> 20% 剩余）
- 数据库连接数（< 最大连接数的 80%）

---

选择适合您环境的部署方案，确保博客系统后端稳定持久运行！

> 💡 **提示**：生产环境部署建议先在测试环境验证，确保配置正确后再部署到生产环境。
