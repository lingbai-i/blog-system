# Blog System 后端持久化部署指南

本文档提供了多种方式来实现博客系统后端的持久化运行，解决开发环境中后端服务频繁终止的问题。

## 方案一：Windows 服务部署（推荐）

### 前置条件

1. 已安装 Java 17 或更高版本
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



## 配置文件说明

### 生产环境配置 (`application-prod.yml`)

- 优化的数据库连接池
- 生产级别的日志配置
- 性能调优参数
- 健康检查端点



## 监控和维护

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

## 推荐部署方案

- **开发环境**：使用 `start-backend.bat` 脚本
- **测试环境**：使用直接运行方式
- **生产环境**：使用 Windows 服务 + 生产配置

选择适合您环境的部署方案，确保博客系统后端稳定持久运行！
