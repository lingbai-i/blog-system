# NSSM 安装和配置指南

NSSM (Non-Sucking Service Manager) 是一个用于将任何应用程序注册为 Windows 服务的工具。本指南将帮助您正确安装和配置 NSSM 以部署博客系统后端服务。

## 📥 下载 NSSM

### 官方下载

1. 访问 NSSM 官方网站：https://nssm.cc/download
2. 下载最新版本的 NSSM（推荐下载 2.24 或更高版本）
3. 解压下载的压缩包

### 文件结构

解压后的文件夹结构如下：
```
nssm-2.24/
├── win32/
│   └── nssm.exe    # 32位版本
└── win64/
    └── nssm.exe    # 64位版本
```

## 🔧 安装配置

### 方法一：复制到项目目录（推荐）

1. 根据您的系统架构选择对应的 `nssm.exe`：
   - 64位系统：使用 `win64/nssm.exe`
   - 32位系统：使用 `win32/nssm.exe`

2. 将 `nssm.exe` 复制到博客系统项目根目录：
   ```
   blog-system/
   ├── nssm.exe          # 复制到这里
   ├── install-service.bat
   ├── manage-service.bat
   └── ...
   ```

### 方法二：添加到系统 PATH

1. 将 NSSM 解压到一个固定目录，例如：`C:\Tools\nssm\`
2. 将该目录添加到系统环境变量 PATH 中：
   - 右键 "此电脑" → "属性" → "高级系统设置"
   - 点击 "环境变量"
   - 在 "系统变量" 中找到 "Path"，点击 "编辑"
   - 添加 NSSM 目录路径：`C:\Tools\nssm\win64`
   - 确定保存

## 🚀 使用方法

### 自动安装（推荐）

使用项目提供的安装脚本：

```cmd
# 以管理员身份运行
install-service.bat
```

### 手动安装

如果需要手动配置，可以使用以下命令：

```cmd
# 安装服务
nssm install BlogSystemBackend "C:\Program Files\Java\jdk-17\bin\java.exe"

# 设置启动参数
nssm set BlogSystemBackend Parameters "-jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod target\blog-system-0.0.1-SNAPSHOT.jar"

# 设置工作目录
nssm set BlogSystemBackend AppDirectory "C:\path\to\blog-system"

# 设置服务显示名称
nssm set BlogSystemBackend DisplayName "Blog System Backend Service"

# 设置服务描述
nssm set BlogSystemBackend Description "博客系统后端服务"

# 设置自动启动
nssm set BlogSystemBackend Start SERVICE_AUTO_START

# 设置日志文件
nssm set BlogSystemBackend AppStdout "C:\path\to\blog-system\logs\service-stdout.log"
nssm set BlogSystemBackend AppStderr "C:\path\to\blog-system\logs\service-stderr.log"

# 启动服务
nssm start BlogSystemBackend
```

## 🛠️ 服务管理

### 使用管理脚本

```cmd
# 运行服务管理工具
manage-service.bat
```

### 手动管理命令

```cmd
# 启动服务
nssm start BlogSystemBackend

# 停止服务
nssm stop BlogSystemBackend

# 重启服务
nssm restart BlogSystemBackend

# 查看服务状态
nssm status BlogSystemBackend

# 编辑服务配置
nssm edit BlogSystemBackend

# 卸载服务
nssm remove BlogSystemBackend confirm
```

## 📋 配置参数说明

| 参数 | 说明 | 示例值 |
|------|------|--------|
| Application | 应用程序路径 | `C:\Program Files\Java\jdk-17\bin\java.exe` |
| Parameters | 启动参数 | `-jar -Xms512m -Xmx1024m target\blog-system.jar` |
| AppDirectory | 工作目录 | `C:\path\to\blog-system` |
| DisplayName | 服务显示名称 | `Blog System Backend Service` |
| Description | 服务描述 | `博客系统后端服务` |
| Start | 启动类型 | `SERVICE_AUTO_START` |
| AppStdout | 标准输出日志 | `logs\service-stdout.log` |
| AppStderr | 错误输出日志 | `logs\service-stderr.log` |

## 🔍 故障排除

### 常见问题

1. **权限不足**
   - 确保以管理员身份运行命令
   - 检查 NSSM 是否有执行权限

2. **Java 路径错误**
   - 确认 JAVA_HOME 环境变量已设置
   - 检查 Java 可执行文件路径是否正确

3. **服务启动失败**
   - 检查 JAR 文件是否存在
   - 查看服务日志文件
   - 确认端口未被占用

4. **日志文件无法创建**
   - 确保 logs 目录存在
   - 检查目录写入权限

### 调试方法

1. **查看服务状态**
   ```cmd
   nssm status BlogSystemBackend
   sc query BlogSystemBackend
   ```

2. **查看服务日志**
   ```cmd
   type logs\service-stdout.log
   type logs\service-stderr.log
   ```

3. **手动测试启动**
   ```cmd
   java -jar -Dspring.profiles.active=prod target\blog-system-0.0.1-SNAPSHOT.jar
   ```

## 📚 更多信息

- NSSM 官方文档：https://nssm.cc/usage
- Windows 服务管理：`services.msc`
- 事件查看器：`eventvwr.msc`

## 🔒 安全建议

1. **服务账户**：建议为服务创建专用的低权限账户
2. **文件权限**：确保服务账户对应用目录有适当权限
3. **网络安全**：配置防火墙规则，只开放必要端口
4. **日志监控**：定期检查服务日志，及时发现异常

---

> 💡 **提示**：如果您不熟悉命令行操作，建议使用项目提供的 `install-service.bat` 和 `manage-service.bat` 脚本进行自动化管理。