@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ========================================
REM 博客系统健康检查脚本
REM 检查应用程序、数据库、服务等状态
REM ========================================

echo.
echo ==========================================
echo          博客系统健康检查工具
echo ==========================================
echo.

REM 设置默认配置
set "APP_HOST=localhost"
set "APP_PORT=8080"
set "MANAGEMENT_PORT=8081"
set "DB_HOST=localhost"
set "DB_PORT=3306"
set "DB_NAME=blog_system"
set "DB_USER=root"
set "SERVICE_NAME=BlogSystemBackend"
set "DOCKER_CONTAINER=blog-system-backend-1"
set "CHECK_ALL=true"

REM 检查参数
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="help" goto :show_help

REM 解析命令行参数
:parse_args
if "%1"=="" goto :start_check
if "%1"=="--docker" (
    set "USE_DOCKER=true"
    shift
    goto :parse_args
)
if "%1"=="--service" (
    set "CHECK_SERVICE=true"
    set "CHECK_ALL=false"
    shift
    goto :parse_args
)
if "%1"=="--app" (
    set "CHECK_APP=true"
    set "CHECK_ALL=false"
    shift
    goto :parse_args
)
if "%1"=="--database" (
    set "CHECK_DATABASE=true"
    set "CHECK_ALL=false"
    shift
    goto :parse_args
)
if "%1"=="--ports" (
    set "CHECK_PORTS=true"
    set "CHECK_ALL=false"
    shift
    goto :parse_args
)
if "%1"=="--host" (
    set "APP_HOST=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--app-port" (
    set "APP_PORT=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--mgmt-port" (
    set "MANAGEMENT_PORT=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--db-host" (
    set "DB_HOST=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--db-port" (
    set "DB_PORT=%2"
    shift
    shift
    goto :parse_args
)
shift
goto :parse_args

:start_check
set "overall_status=OK"
set "check_count=0"
set "failed_count=0"

echo 健康检查配置:
echo   应用主机: %APP_HOST%:%APP_PORT%
echo   管理端口: %MANAGEMENT_PORT%
echo   数据库: %DB_HOST%:%DB_PORT%
if defined USE_DOCKER (
    echo   Docker模式: 启用
    echo   容器名称: %DOCKER_CONTAINER%
)
echo.

REM 执行检查
if "%CHECK_ALL%"=="true" (
    call :check_ports
    call :check_service_status
    call :check_application_health
    call :check_database_connection
    call :check_disk_space
    call :check_memory_usage
) else (
    if defined CHECK_PORTS call :check_ports
    if defined CHECK_SERVICE call :check_service_status
    if defined CHECK_APP call :check_application_health
    if defined CHECK_DATABASE call :check_database_connection
)

REM 显示总结
echo.
echo ==========================================
echo              健康检查总结
echo ==========================================
echo 总检查项: %check_count%
echo 失败项数: %failed_count%
echo 整体状态: %overall_status%
echo.

if "%overall_status%"=="FAILED" (
    echo [警告] 系统存在问题，请检查上述失败项！
    exit /b 1
) else (
    echo [成功] 系统运行正常！
    exit /b 0
)

REM ========================================
REM 检查端口占用
REM ========================================
:check_ports
echo [检查] 端口状态...
set /a check_count+=1

REM 检查应用端口
netstat -an | findstr ":%APP_PORT% " | findstr "LISTENING" >nul
if errorlevel 1 (
    echo   ❌ 应用端口 %APP_PORT% 未监听
    set "overall_status=FAILED"
    set /a failed_count+=1
) else (
    echo   ✅ 应用端口 %APP_PORT% 正常监听
)

REM 检查管理端口
netstat -an | findstr ":%MANAGEMENT_PORT% " | findstr "LISTENING" >nul
if errorlevel 1 (
    echo   ❌ 管理端口 %MANAGEMENT_PORT% 未监听
    set "overall_status=FAILED"
    set /a failed_count+=1
) else (
    echo   ✅ 管理端口 %MANAGEMENT_PORT% 正常监听
)

echo.
exit /b 0

REM ========================================
REM 检查服务状态
REM ========================================
:check_service_status
if defined USE_DOCKER (
    call :check_docker_status
) else (
    call :check_windows_service
)
exit /b 0

:check_docker_status
echo [检查] Docker容器状态...
set /a check_count+=1

REM 检查Docker是否运行
docker --version >nul 2>&1
if errorlevel 1 (
    echo   ❌ Docker未安装或未运行
    set "overall_status=FAILED"
    set /a failed_count+=1
    echo.
    exit /b 0
)

REM 检查容器状态
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr /C:"%DOCKER_CONTAINER%" >nul
if errorlevel 1 (
    echo   ❌ Docker容器 '%DOCKER_CONTAINER%' 未运行
    set "overall_status=FAILED"
    set /a failed_count+=1
    
    REM 检查容器是否存在但未运行
    docker ps -a --format "table {{.Names}}\t{{.Status}}" | findstr /C:"%DOCKER_CONTAINER%" >nul
    if not errorlevel 1 (
        echo   ℹ️  容器存在但未运行，状态:
        docker ps -a --format "table {{.Names}}\t{{.Status}}" | findstr /C:"%DOCKER_CONTAINER%"
    )
) else (
    echo   ✅ Docker容器 '%DOCKER_CONTAINER%' 正常运行
    
    REM 显示容器详细状态
    for /f "tokens=2" %%a in ('docker ps --format "table {{.Names}}\t{{.Status}}" ^| findstr /C:"%DOCKER_CONTAINER%"') do (
        echo   ℹ️  容器状态: %%a
    )
)

echo.
exit /b 0

:check_windows_service
echo [检查] Windows服务状态...
set /a check_count+=1

REM 检查服务是否存在
sc query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 (
    echo   ❌ Windows服务 '%SERVICE_NAME%' 不存在
    set "overall_status=FAILED"
    set /a failed_count+=1
    echo.
    exit /b 0
)

REM 检查服务状态
for /f "tokens=3" %%a in ('sc query "%SERVICE_NAME%" ^| findstr "STATE"') do (
    set "service_state=%%a"
)

if "%service_state%"=="RUNNING" (
    echo   ✅ Windows服务 '%SERVICE_NAME%' 正常运行
) else (
    echo   ❌ Windows服务 '%SERVICE_NAME%' 状态异常: %service_state%
    set "overall_status=FAILED"
    set /a failed_count+=1
)

echo.
exit /b 0

REM ========================================
REM 检查应用程序健康状态
REM ========================================
:check_application_health
echo [检查] 应用程序健康状态...
set /a check_count+=1

REM 检查健康检查端点
curl -s -f "http://%APP_HOST%:%MANAGEMENT_PORT%/actuator/health" >nul 2>&1
if errorlevel 1 (
    echo   ❌ 健康检查端点无响应
    set "overall_status=FAILED"
    set /a failed_count+=1
) else (
    echo   ✅ 健康检查端点正常响应
    
    REM 获取详细健康状态
    for /f "delims=" %%a in ('curl -s "http://%APP_HOST%:%MANAGEMENT_PORT%/actuator/health" 2^>nul') do (
        echo %%a | findstr "UP" >nul
        if not errorlevel 1 (
            echo   ℹ️  应用状态: UP
        ) else (
            echo   ⚠️  应用状态可能异常
        )
    )
)

REM 检查应用程序API
curl -s -f "http://%APP_HOST%:%APP_PORT%/api/health" >nul 2>&1
if errorlevel 1 (
    echo   ❌ 应用API无响应
    set "overall_status=FAILED"
    set /a failed_count+=1
) else (
    echo   ✅ 应用API正常响应
)

echo.
exit /b 0

REM ========================================
REM 检查数据库连接
REM ========================================
:check_database_connection
echo [检查] 数据库连接...
set /a check_count+=1

REM 检查数据库端口
telnet %DB_HOST% %DB_PORT% 2>nul | findstr "Connected" >nul
if errorlevel 1 (
    REM 使用PowerShell测试连接
    powershell -Command "try { $tcp = New-Object System.Net.Sockets.TcpClient; $tcp.Connect('%DB_HOST%', %DB_PORT%); $tcp.Close(); exit 0 } catch { exit 1 }" >nul 2>&1
    if errorlevel 1 (
        echo   ❌ 无法连接到数据库 %DB_HOST%:%DB_PORT%
        set "overall_status=FAILED"
        set /a failed_count+=1
    ) else (
        echo   ✅ 数据库端口 %DB_HOST%:%DB_PORT% 可访问
    )
) else (
    echo   ✅ 数据库端口 %DB_HOST%:%DB_PORT% 可访问
)

REM 如果有mysql客户端，尝试连接测试
mysql --version >nul 2>&1
if not errorlevel 1 (
    echo   ℹ️  MySQL客户端可用，可进行连接测试
)

echo.
exit /b 0

REM ========================================
REM 检查磁盘空间
REM ========================================
:check_disk_space
echo [检查] 磁盘空间...
set /a check_count+=1

REM 获取当前驱动器的可用空间
for /f "tokens=3" %%a in ('dir /-c ^| findstr "bytes free"') do (
    set "free_space=%%a"
)

REM 简化检查：如果可用空间小于1GB则警告
if %free_space% lss 1073741824 (
    echo   ⚠️  磁盘空间不足，剩余: %free_space% 字节
    set "overall_status=WARNING"
) else (
    echo   ✅ 磁盘空间充足
)

echo.
exit /b 0

REM ========================================
REM 检查内存使用
REM ========================================
:check_memory_usage
echo [检查] 内存使用情况...
set /a check_count+=1

REM 使用wmic获取内存信息
for /f "skip=1 tokens=2" %%a in ('wmic OS get TotalVisibleMemorySize /value ^| findstr "="') do (
    set "total_memory=%%a"
)

for /f "skip=1 tokens=2" %%a in ('wmic OS get FreePhysicalMemory /value ^| findstr "="') do (
    set "free_memory=%%a"
)

if defined total_memory if defined free_memory (
    set /a "memory_usage_percent=(total_memory-free_memory)*100/total_memory"
    
    if !memory_usage_percent! gtr 90 (
        echo   ⚠️  内存使用率过高: !memory_usage_percent!%%
        set "overall_status=WARNING"
    ) else (
        echo   ✅ 内存使用率正常: !memory_usage_percent!%%
    )
) else (
    echo   ℹ️  无法获取内存使用信息
)

echo.
exit /b 0

REM ========================================
REM 显示帮助信息
REM ========================================
:show_help
echo.
echo 博客系统健康检查工具
echo.
echo 用法:
echo   health-check.bat [选项]
echo.
echo 选项:
echo   --docker              使用Docker模式检查
echo   --service             仅检查服务状态
echo   --app                 仅检查应用程序健康状态
echo   --database            仅检查数据库连接
echo   --ports               仅检查端口状态
echo   --host HOST           应用主机地址 (默认: localhost)
echo   --app-port PORT       应用端口 (默认: 8080)
echo   --mgmt-port PORT      管理端口 (默认: 8081)
echo   --db-host HOST        数据库主机 (默认: localhost)
echo   --db-port PORT        数据库端口 (默认: 3306)
echo   --help, -h            显示此帮助信息
echo.
echo 示例:
echo   # 完整健康检查
echo   health-check.bat
echo.
echo   # Docker环境检查
echo   health-check.bat --docker
echo.
echo   # 仅检查应用程序
echo   health-check.bat --app
echo.
echo   # 自定义主机检查
echo   health-check.bat --host 192.168.1.100 --app-port 8080
echo.
echo 返回值:
echo   0 - 所有检查通过
echo   1 - 存在失败项
echo.
exit /b 0