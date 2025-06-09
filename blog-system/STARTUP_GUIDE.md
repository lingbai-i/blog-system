# 博客系统启动指南

本项目提供了三个便捷的启动脚本，满足不同的使用场景。

## 🚀 启动脚本说明

### 1. `start.bat` - 完整启动脚本

**功能最全面的启动脚本，适合开发和生产环境**

```bash
# 双击运行或命令行执行
start.bat
```

**功能菜单：**

- ✅ 完整启动 (构建+后端+前端)
- ✅ 仅启动后端
- ✅ 仅启动前端
- ✅ 构建项目
- ✅ 测试 API
- ✅ 停止所有服务

### 2. `quick-start.bat` - 快速启动脚本

**一键启动，适合日常开发使用**

```bash
# 双击运行，自动完成所有启动流程
quick-start.bat
```

**自动执行：**

1. 构建后端项目
2. 启动后端服务 (端口 8080)
3. 启动前端服务 (端口 3000)
4. 测试连接状态

### 3. `dev-tools-en.bat` - 开发工具脚本

**提供开发和维护功能**

```bash
# 开发和维护工具（英文版）
dev-tools-en.bat
```

**工具功能：**

- 🔄 重置数据库
- 🧹 清理构建缓存
- 📊 查看系统状态
- 📋 查看日志
- ⚡ 性能监控
- 💾 备份数据库
- 📚 生成 API 文档
- 🎨 代码格式化

## 🔧 环境要求

### 必需环境

- **Java 21+** (推荐设置 `JAVA_HOME` 环境变量)
- **Maven 3.6+**
- **Node.js 16+** 和 **npm**
- **MySQL 8.0+**

### 可选环境

- **curl** (用于 API 测试)
- **Git** (用于版本控制)

## 📋 使用步骤

### 首次启动

1. **配置数据库**

   ```sql
   -- 创建数据库
   CREATE DATABASE blog_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

   -- 导入初始数据
   mysql -u root -p blog_system < src/main/resources/schema.sql
   ```

2. **快速启动**

   ```bash
   # 双击运行快速启动脚本
   quick-start.bat
   ```

3. **访问系统**
   - 前端地址: http://localhost:3000
   - 后端 API: http://localhost:8080
   - 管理后台: http://localhost:3000/admin

### 日常开发

```bash
# 快速启动开发环境
quick-start.bat

# 或使用完整脚本进行精细控制
start.bat
```

### 系统维护

```bash
# 使用开发工具进行维护
dev-tools.bat
```

## 🔐 默认账号

| 角色   | 账号    | 密码       | 说明       |
| ------ | ------- | ---------- | ---------- |
| 管理员 | admin   | admin123   | 系统管理员 |
| 博主   | blogger | blogger123 | 博客作者   |
| 用户   | reader  | reader123  | 普通用户   |

## 🚨 常见问题

### 端口冲突

如果遇到端口占用问题：

```bash
# 查看端口占用
netstat -ano | findstr :8080
netstat -ano | findstr :3000

# 或使用开发工具检查
dev-tools-en.bat -> 查看系统状态
```

### 构建失败

1. 检查 Java 和 Maven 环境
2. 清理缓存后重新构建：
   ```bash
   dev-tools-en.bat -> 清理构建缓存
   ```

### 数据库连接失败

1. 确认 MySQL 服务已启动
2. 检查数据库配置文件 `application.properties`
3. 重置数据库：
   ```bash
   dev-tools-en.bat -> 重置数据库
   ```

## 📁 项目结构

```
blog-system/
├── start.bat              # 完整启动脚本
├── quick-start.bat        # 快速启动脚本
├── dev-tools-en.bat       # 开发工具脚本（英文版）
├── STARTUP_GUIDE.md       # 启动指南 (本文件)
├── src/                   # 后端源码
├── frontend/              # 前端源码
├── uploads/               # 上传文件目录
└── logs/                  # 日志文件目录
```

## 🎯 推荐使用方式

- **新手用户**: 使用 `quick-start.bat` 一键启动
- **开发人员**: 使用 `start.bat` 进行精细控制
- **系统维护**: 使用 `dev-tools-en.bat` 进行管理和监控

---

💡 **提示**: 所有脚本都支持中文界面，并提供详细的操作提示和错误信息。
