# 博客系统管理脚本

本目录包含了博客系统的各种管理和维护脚本，用于简化系统的部署、监控、备份等操作。

## 📁 脚本列表

### 🗄️ 数据库管理

#### `backup-database.bat`
**功能**: 数据库备份工具

**用途**:
- 支持本地和Docker环境的MySQL数据库备份
- 自动生成带时间戳的备份文件
- 自动清理过期备份文件
- 支持自定义备份目录和保留天数

**使用方法**:
```cmd
# 本地环境备份
backup-database.bat

# Docker环境备份
backup-database.bat --docker

# 自定义配置备份
backup-database.bat --host 192.168.1.100 --user blog_user --retention 7
```

**参数说明**:
- `--docker`: 使用Docker容器进行备份
- `--host HOST`: 数据库主机地址
- `--port PORT`: 数据库端口
- `--database DB`: 数据库名称
- `--user USER`: 数据库用户
- `--backup-dir DIR`: 备份目录
- `--retention DAYS`: 备份保留天数
- `--container NAME`: Docker容器名称

---

#### `restore-database.bat`
**功能**: 数据库恢复工具

**用途**:
- 从备份文件恢复数据库
- 支持交互式选择备份文件
- 支持本地和Docker环境
- 提供安全确认机制

**使用方法**:
```cmd
# 交互式选择备份文件恢复
restore-database.bat

# Docker环境恢复
restore-database.bat --docker

# 指定备份文件恢复
restore-database.bat --file "backups\blog_system_backup_20231201_120000.sql"
```

**参数说明**:
- `--docker`: 使用Docker容器进行恢复
- `--file FILE`: 指定备份文件路径
- `--host HOST`: 数据库主机地址
- `--port PORT`: 数据库端口
- `--user USER`: 数据库用户
- `--container NAME`: Docker容器名称

---

### 🔍 系统监控

#### `health-check.bat`
**功能**: 系统健康检查工具

**用途**:
- 检查应用程序状态
- 检查数据库连接
- 检查端口监听状态
- 检查服务运行状态
- 检查系统资源使用情况

**使用方法**:
```cmd
# 完整健康检查
health-check.bat

# Docker环境检查
health-check.bat --docker

# 仅检查应用程序
health-check.bat --app

# 自定义主机检查
health-check.bat --host 192.168.1.100 --app-port 8080
```

**参数说明**:
- `--docker`: 使用Docker模式检查
- `--service`: 仅检查服务状态
- `--app`: 仅检查应用程序健康状态
- `--database`: 仅检查数据库连接
- `--ports`: 仅检查端口状态
- `--host HOST`: 应用主机地址
- `--app-port PORT`: 应用端口
- `--mgmt-port PORT`: 管理端口

**返回值**:
- `0`: 所有检查通过
- `1`: 存在失败项

---

#### `monitor-system.bat`
**功能**: 系统持续监控工具

**用途**:
- 持续监控系统状态
- 自动记录监控日志
- 资源使用率告警
- 生成监控报告
- 自动清理旧日志

**使用方法**:
```cmd
# 开始持续监控
monitor-system.bat

# 自定义监控间隔
monitor-system.bat --interval 30

# 执行单次检查
monitor-system.bat --once

# 生成监控报告
monitor-system.bat --report
```

**参数说明**:
- `--interval SECONDS`: 监控间隔秒数
- `--host HOST`: 应用主机地址
- `--app-port PORT`: 应用端口
- `--mgmt-port PORT`: 管理端口
- `--log-dir DIR`: 日志目录
- `--once`: 执行单次检查后退出
- `--report`: 生成监控报告

**监控内容**:
- 应用程序状态和健康检查
- 系统资源使用情况 (CPU、内存)
- 磁盘空间使用情况
- 网络连接状态
- 错误日志检查
- 自动告警和报告生成

---

## 🚀 快速开始

### 1. 系统健康检查
首次部署后，建议先进行系统健康检查：
```cmd
cd scripts
health-check.bat
```

### 2. 设置数据库备份
配置定期数据库备份：
```cmd
# 手动备份
backup-database.bat

# 或者使用Windows任务计划程序设置定期备份
```

### 3. 启动系统监控
开始持续监控系统状态：
```cmd
# 在后台启动监控（建议使用任务计划程序）
monitor-system.bat --interval 300
```

---

## 📋 最佳实践

### 🔄 定期维护

1. **每日检查**
   ```cmd
   health-check.bat
   ```

2. **每日备份**
   ```cmd
   backup-database.bat --retention 30
   ```

3. **每周报告**
   ```cmd
   monitor-system.bat --report
   ```

### ⚠️ 告警设置

监控脚本会在以下情况发出告警：
- CPU使用率 > 80%
- 内存使用率 > 85%
- 磁盘使用率 > 90%
- 应用程序无响应
- 数据库连接失败

### 📊 日志管理

- **监控日志**: `../logs/monitor/monitor_YYYYMMDD.log`
- **备份日志**: 备份脚本会记录操作日志
- **应用日志**: `../logs/blog-system.log`

---

## 🛠️ 故障排除

### 常见问题

1. **权限不足**
   - 以管理员身份运行脚本
   - 检查文件和目录权限

2. **端口被占用**
   ```cmd
   netstat -ano | findstr :8080
   ```

3. **数据库连接失败**
   - 检查数据库服务状态
   - 验证连接参数
   - 检查防火墙设置

4. **Docker相关问题**
   ```cmd
   docker ps -a
   docker logs container_name
   ```

### 调试模式

大多数脚本支持详细输出，可以通过查看日志文件获取更多信息：
```cmd
# 查看最新的监控日志
type ..\logs\monitor\monitor_*.log | more

# 查看应用日志
type ..\logs\blog-system.log | more
```

---

## 🔧 自定义配置

### 环境变量

可以通过设置环境变量来自定义脚本行为：

```cmd
set BLOG_APP_HOST=192.168.1.100
set BLOG_APP_PORT=8080
set BLOG_DB_HOST=192.168.1.101
set BLOG_DB_PORT=3306
```

### 配置文件

部分脚本支持配置文件，可以在脚本同目录下创建 `config.bat` 文件：

```cmd
REM config.bat
set "DEFAULT_HOST=192.168.1.100"
set "DEFAULT_APP_PORT=8080"
set "DEFAULT_MGMT_PORT=8081"
set "DEFAULT_BACKUP_DIR=D:\backups\blog-system"
```

---

## 📞 技术支持

如果在使用脚本过程中遇到问题：

1. 查看脚本帮助信息：`script_name.bat --help`
2. 检查日志文件获取详细错误信息
3. 确认系统环境和依赖项
4. 参考 `DEPLOYMENT.md` 文档

---

## 📝 更新日志

- **v1.0.0**: 初始版本，包含基础的备份、恢复、健康检查和监控功能
- 支持本地和Docker环境
- 提供详细的日志记录和告警机制
- 包含自动化的维护功能

---

> 💡 **提示**: 建议将这些脚本添加到Windows任务计划程序中，实现自动化的系统维护和监控。