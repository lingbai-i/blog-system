@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ========================================
REM 博客系统数据库恢复脚本
REM 支持本地和Docker环境的MySQL数据库恢复
REM ========================================

echo.
echo ==========================================
echo          博客系统数据库恢复工具
echo ==========================================
echo.

REM 设置默认配置
set "DB_HOST=localhost"
set "DB_PORT=3306"
set "DB_NAME=blog_system"
set "DB_USER=root"
set "BACKUP_DIR=%~dp0..\backups"
set "DOCKER_CONTAINER=blog-system-mysql-1"
set "BACKUP_FILE="

REM 检查参数
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="help" goto :show_help

REM 解析命令行参数
:parse_args
if "%1"=="" goto :check_backup_file
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
if "%1"=="--file" (
    set "BACKUP_FILE=%2"
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

:check_backup_file
REM 如果没有指定备份文件，列出可用的备份文件
if "%BACKUP_FILE%"=="" (
    call :list_backup_files
    if errorlevel 1 exit /b 1
)

REM 检查备份文件是否存在
if not exist "%BACKUP_FILE%" (
    echo [错误] 备份文件不存在: %BACKUP_FILE%
    echo.
    call :list_backup_files
    exit /b 1
)

REM 显示恢复配置
echo 恢复配置:
echo   数据库主机: %DB_HOST%:%DB_PORT%
echo   数据库名称: %DB_NAME%
echo   数据库用户: %DB_USER%
echo   备份文件: %BACKUP_FILE%
if defined USE_DOCKER (
    echo   Docker容器: %DOCKER_CONTAINER%
)
echo.

REM 确认恢复操作
echo [警告] 此操作将覆盖现有数据库数据！
set /p "CONFIRM=确认要恢复数据库吗？(y/N): "
if /i not "%CONFIRM%"=="y" (
    echo 操作已取消
    exit /b 0
)

echo.
echo 开始恢复数据库...

REM 执行恢复
if defined USE_DOCKER (
    call :restore_docker
) else (
    call :restore_local
)

if errorlevel 1 (
    echo [错误] 数据库恢复失败！
    exit /b 1
)

echo.
echo [成功] 数据库恢复完成！
echo 恢复文件: %BACKUP_FILE%
echo.
exit /b 0

REM ========================================
REM 列出可用的备份文件
REM ========================================
:list_backup_files
echo 可用的备份文件:
echo.

if not exist "%BACKUP_DIR%" (
    echo [错误] 备份目录不存在: %BACKUP_DIR%
    exit /b 1
)

set "file_count=0"
for %%f in ("%BACKUP_DIR%\blog_system_backup_*.sql") do (
    set /a file_count+=1
    echo   !file_count!. %%~nxf (%%~zf 字节)
    set "file_!file_count!=%%f"
)

if %file_count%==0 (
    echo   (没有找到备份文件)
    echo.
    echo 请先运行备份脚本创建备份文件:
    echo   backup-database.bat
    exit /b 1
)

echo.
set /p "file_choice=请选择要恢复的备份文件 (1-%file_count%): "

REM 验证选择
if "%file_choice%"=="" (
    echo 操作已取消
    exit /b 1
)

if %file_choice% lss 1 (
    echo [错误] 无效的选择
    exit /b 1
)

if %file_choice% gtr %file_count% (
    echo [错误] 无效的选择
    exit /b 1
)

REM 设置选择的文件
call set "BACKUP_FILE=%%file_%file_choice%%%"
echo.
echo 已选择: %BACKUP_FILE%
echo.
exit /b 0

REM ========================================
REM Docker环境恢复
REM ========================================
:restore_docker
echo 正在恢复到Docker容器...

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

REM 复制备份文件到容器
echo 复制备份文件到容器...
docker cp "%BACKUP_FILE%" %DOCKER_CONTAINER%:/tmp/restore.sql
if errorlevel 1 (
    echo [错误] 无法复制备份文件到容器
    exit /b 1
)

REM 执行恢复
echo 执行恢复命令...
docker exec %DOCKER_CONTAINER% mysql -u%DB_USER% -p%MYSQL_ROOT_PASSWORD% < /tmp/restore.sql
if errorlevel 1 (
    echo [错误] Docker恢复命令执行失败
    exit /b 1
)

REM 清理临时文件
docker exec %DOCKER_CONTAINER% rm -f /tmp/restore.sql

echo Docker恢复完成
exit /b 0

REM ========================================
REM 本地环境恢复
REM ========================================
:restore_local
echo 正在恢复到本地数据库...

REM 检查mysql是否可用
mysql --version >nul 2>&1
if errorlevel 1 (
    echo [错误] mysql 命令不可用
    echo 请确保MySQL客户端工具已安装并添加到PATH环境变量
    exit /b 1
)

REM 提示输入密码
echo 请输入数据库密码:
set /p "DB_PASSWORD=密码: "

REM 测试数据库连接
echo 测试数据库连接...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo [错误] 无法连接到数据库
    exit /b 1
)

REM 执行恢复
echo 执行恢复命令...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% < "%BACKUP_FILE%"
if errorlevel 1 (
    echo [错误] 恢复命令执行失败
    exit /b 1
)

echo 本地恢复完成
exit /b 0

REM ========================================
REM 显示帮助信息
REM ========================================
:show_help
echo.
echo 博客系统数据库恢复工具
echo.
echo 用法:
echo   restore-database.bat [选项]
echo.
echo 选项:
echo   --docker              使用Docker容器进行恢复
echo   --host HOST           数据库主机地址 (默认: localhost)
echo   --port PORT           数据库端口 (默认: 3306)
echo   --database DB         数据库名称 (默认: blog_system)
echo   --user USER           数据库用户 (默认: root)
echo   --backup-dir DIR      备份目录 (默认: ..\backups)
echo   --file FILE           指定备份文件路径
echo   --container NAME      Docker容器名称 (默认: blog-system-mysql-1)
echo   --help, -h            显示此帮助信息
echo.
echo 示例:
echo   # 交互式选择备份文件恢复
echo   restore-database.bat
echo.
echo   # Docker环境恢复
echo   restore-database.bat --docker
echo.
echo   # 指定备份文件恢复
echo   restore-database.bat --file "backups\blog_system_backup_20231201_120000.sql"
echo.
echo   # 自定义配置恢复
echo   restore-database.bat --host 192.168.1.100 --user blog_user
echo.
echo   # Docker自定义容器恢复
echo   restore-database.bat --docker --container my-mysql-container
echo.
echo 注意事项:
echo   - 恢复操作将覆盖现有数据库数据
echo   - 请确保在恢复前已停止应用程序
echo   - 建议在恢复前先备份当前数据
echo.
exit /b 0