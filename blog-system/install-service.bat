@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo    博客系统后端服务安装脚本
echo ========================================
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本！
    echo 右键点击脚本文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

:: 检查JAVA_HOME
if "%JAVA_HOME%"=="" (
    echo [错误] 未设置 JAVA_HOME 环境变量！
    echo 请先安装 Java 21+ 并设置 JAVA_HOME
    pause
    exit /b 1
)

:: 检查Java版本
echo [信息] 检查Java版本...
"%JAVA_HOME%\bin\java" -version 2>&1 | findstr "version" >nul
if %errorLevel% neq 0 (
    echo [错误] Java 未正确安装或配置！
    pause
    exit /b 1
)

:: 检查NSSM
if not exist "nssm.exe" (
    echo [错误] 未找到 nssm.exe 文件！
    echo 请从 https://nssm.cc/download 下载 NSSM 并将 nssm.exe 放在项目根目录
    pause
    exit /b 1
)

:: 构建项目
echo [信息] 构建项目...
call mvnw.cmd clean package -DskipTests
if %errorLevel% neq 0 (
    echo [错误] 项目构建失败！
    pause
    exit /b 1
)

:: 查找JAR文件
set "JAR_FILE="
for %%f in (target\*.jar) do (
    if not "%%~nf"=="%%~nf.original" (
        set "JAR_FILE=%%f"
    )
)

if "%JAR_FILE%"=="" (
    echo [错误] 未找到构建的JAR文件！
    pause
    exit /b 1
)

echo [信息] 找到JAR文件: %JAR_FILE%

:: 创建必要目录
if not exist "logs" mkdir logs
if not exist "uploads" mkdir uploads
if not exist "uploads\avatars" mkdir "uploads\avatars"

:: 获取当前目录的绝对路径
set "CURRENT_DIR=%~dp0"
set "CURRENT_DIR=%CURRENT_DIR:~0,-1%"

:: 安装服务
echo [信息] 安装Windows服务...
nssm install BlogSystemBackend "%JAVA_HOME%\bin\java.exe"
nssm set BlogSystemBackend Parameters "-jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod \"%CURRENT_DIR%\%JAR_FILE%\""
nssm set BlogSystemBackend AppDirectory "%CURRENT_DIR%"
nssm set BlogSystemBackend DisplayName "Blog System Backend Service"
nssm set BlogSystemBackend Description "博客系统后端服务 - 提供API接口和数据管理"
nssm set BlogSystemBackend Start SERVICE_AUTO_START
nssm set BlogSystemBackend AppStdout "%CURRENT_DIR%\logs\service-stdout.log"
nssm set BlogSystemBackend AppStderr "%CURRENT_DIR%\logs\service-stderr.log"
nssm set BlogSystemBackend AppRotateFiles 1
nssm set BlogSystemBackend AppRotateOnline 1
nssm set BlogSystemBackend AppRotateSeconds 86400
nssm set BlogSystemBackend AppRotateBytes 10485760

if %errorLevel% neq 0 (
    echo [错误] 服务安装失败！
    pause
    exit /b 1
)

:: 启动服务
echo [信息] 启动服务...
nssm start BlogSystemBackend

if %errorLevel% neq 0 (
    echo [警告] 服务启动失败，请检查配置
    echo 可以通过 services.msc 手动启动服务
) else (
    echo [成功] 服务安装并启动成功！
)

echo.
echo ========================================
echo 服务安装完成！
echo.
echo 服务名称: BlogSystemBackend
echo 显示名称: Blog System Backend Service
echo 启动类型: 自动
echo 日志目录: %CURRENT_DIR%\logs
echo.
echo 管理命令:
echo   启动服务: nssm start BlogSystemBackend
echo   停止服务: nssm stop BlogSystemBackend
echo   重启服务: nssm restart BlogSystemBackend
echo   卸载服务: nssm remove BlogSystemBackend confirm
echo.
echo 或使用管理脚本: manage-service.bat
echo ========================================
echo.
pause