@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ========================================
REM 博客系统数据库备份脚本
REM 支持本地和Docker环境的MySQL数据库备份
REM ========================================

echo.
echo ==========================================
echo          博客系统数据库备份工具
echo ==========================================
echo.

REM 设置默认配置
set "DB_HOST=localhost"
set "DB_PORT=3306"
set "DB_NAME=blog_system"
set "DB_USER=root"
set "BACKUP_DIR=%~dp0..\backups"
set "RETENTION_DAYS=30"
set "DOCKER_CONTAINER=blog-system-mysql-1"

REM 检查参数
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="help" goto :show_help

REM 解析命令行参数
:parse_args
if "%1"=="" goto :start_backup
if "%1"=="--docker" (
    set "USE_DOCKER=true"
    shift
    goto :parse_args
)
if "%1"=="--host" (
    set "DB_HOST=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--port" (
    set "DB_PORT=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--database" (
    set "DB_NAME=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--user" (
    set "DB_USER=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--backup-dir" (
    set "BACKUP_DIR=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--retention" (
    set "RETENTION_DAYS=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--container" (
    set "DOCKER_CONTAINER=%2"
    shift
    shift
    goto :parse_args
)
shift
goto :parse_args

:start_backup
REM 生成时间戳
for /f "tokens=1-6 delims=/:. " %%a in ('%SystemRoot%\System32\wbem\wmic.exe OS Get localdatetime ^| find "."') do (
    set "timestamp=%%a"
)
set "timestamp=%timestamp:~0,8%_%timestamp:~8,6%"

REM 创建备份目录
if not exist "%BACKUP_DIR%" (
    echo 创建备份目录: %BACKUP_DIR%
    mkdir "%BACKUP_DIR%" 2>nul
    if errorlevel 1 (
        echo [错误] 无法创建备份目录: %BACKUP_DIR%
        exit /b 1
    )
)

REM 设置备份文件名
set "BACKUP_FILE=%BACKUP_DIR%\blog_system_backup_%timestamp%.sql"

echo 备份配置:
echo   数据库主机: %DB_HOST%:%DB_PORT%
echo   数据库名称: %DB_NAME%
echo   数据库用户: %DB_USER%
echo   备份目录: %BACKUP_DIR%
echo   备份文件: %BACKUP_FILE%
echo   保留天数: %RETENTION_DAYS%
if defined USE_DOCKER (
    echo   Docker容器: %DOCKER_CONTAINER%
)
echo.

REM 执行备份
if defined USE_DOCKER (
    call :backup_docker
) else (
    call :backup_local
)

if errorlevel 1 (
    echo [错误] 数据库备份失败！
    exit /b 1
)

REM 清理旧备份
call :cleanup_old_backups

echo.
echo [成功] 数据库备份完成！
echo 备份文件: %BACKUP_FILE%
echo 文件大小: 
for %%F in ("%BACKUP_FILE%") do echo   %%~zF 字节
echo.
exit /b 0

REM ========================================
REM Docker环境备份
REM ========================================
:backup_docker
echo 正在从Docker容器备份数据库...

REM 检查Docker是否运行
docker --version >nul 2>&1
if errorlevel 1 (
    echo [错误] Docker未安装或未运行
    exit /b 1
)

REM 检查容器是否存在
docker ps -a --format "table {{.Names}}" | findstr /C:"%DOCKER_CONTAINER%" >nul
if errorlevel 1 (
    echo [错误] Docker容器 '%DOCKER_CONTAINER%' 不存在
    echo 可用的容器:
    docker ps -a --format "table {{.Names}}\t{{.Status}}"
    exit /b 1
)

REM 检查容器是否运行
docker ps --format "table {{.Names}}" | findstr /C:"%DOCKER_CONTAINER%" >nul
if errorlevel 1 (
    echo [错误] Docker容器 '%DOCKER_CONTAINER%' 未运行
    exit /b 1
)

REM 执行Docker备份
echo 执行备份命令...
docker exec %DOCKER_CONTAINER% mysqldump -u%DB_USER% -p%MYSQL_ROOT_PASSWORD% --single-transaction --routines --triggers --all-databases > "%BACKUP_FILE%"
if errorlevel 1 (
    echo [错误] Docker备份命令执行失败
    exit /b 1
)

echo Docker备份完成
exit /b 0

REM ========================================
REM 本地环境备份
REM ========================================
:backup_local
echo 正在备份本地数据库...

REM 检查mysqldump是否可用
mysqldump --version >nul 2>&1
if errorlevel 1 (
    echo [错误] mysqldump 命令不可用
    echo 请确保MySQL客户端工具已安装并添加到PATH环境变量
    exit /b 1
)

REM 提示输入密码
echo 请输入数据库密码:
set /p "DB_PASSWORD=密码: "

REM 执行备份
echo 执行备份命令...
mysqldump -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% --single-transaction --routines --triggers --databases %DB_NAME% > "%BACKUP_FILE%"
if errorlevel 1 (
    echo [错误] 备份命令执行失败
    exit /b 1
)

echo 本地备份完成
exit /b 0

REM ========================================
REM 清理旧备份文件
REM ========================================
:cleanup_old_backups
echo 正在清理 %RETENTION_DAYS% 天前的备份文件...

REM 计算删除日期
for /f "tokens=1-3 delims=/" %%a in ('date /t') do (
    set "current_date=%%c%%a%%b"
)

REM 删除旧文件（简化版本，实际应该计算日期差）
forfiles /p "%BACKUP_DIR%" /m "blog_system_backup_*.sql" /d -%RETENTION_DAYS% /c "cmd /c echo 删除旧备份: @path && del @path" 2>nul

echo 清理完成
exit /b 0

REM ========================================
REM 显示帮助信息
REM ========================================
:show_help
echo.
echo 博客系统数据库备份工具
echo.
echo 用法:
echo   backup-database.bat [选项]
echo.
echo 选项:
echo   --docker              使用Docker容器进行备份
echo   --host HOST           数据库主机地址 (默认: localhost)
echo   --port PORT           数据库端口 (默认: 3306)
echo   --database DB         数据库名称 (默认: blog_system)
echo   --user USER           数据库用户 (默认: root)
echo   --backup-dir DIR      备份目录 (默认: ..\backups)
echo   --retention DAYS      备份保留天数 (默认: 30)
echo   --container NAME      Docker容器名称 (默认: blog-system-mysql-1)
echo   --help, -h            显示此帮助信息
echo.
echo 示例:
echo   # 本地备份
echo   backup-database.bat
echo.
echo   # Docker备份
echo   backup-database.bat --docker
echo.
echo   # 自定义配置
echo   backup-database.bat --host 192.168.1.100 --user blog_user --retention 7
echo.
echo   # Docker自定义容器
echo   backup-database.bat --docker --container my-mysql-container
echo.
exit /b 0