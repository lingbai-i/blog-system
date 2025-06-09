@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ========================================
REM 博客系统监控脚本
REM 持续监控系统状态并生成监控报告
REM ========================================

echo.
echo ==========================================
echo          博客系统监控工具
echo ==========================================
echo.

REM 设置默认配置
set "APP_HOST=localhost"
set "APP_PORT=8080"
set "MANAGEMENT_PORT=8081"
set "MONITOR_INTERVAL=60"
set "LOG_DIR=%~dp0..\logs\monitor"
set "REPORT_DIR=%~dp0..\reports"
set "MAX_LOG_FILES=7"
set "ALERT_THRESHOLD_CPU=80"
set "ALERT_THRESHOLD_MEMORY=85"
set "ALERT_THRESHOLD_DISK=90"

REM 检查参数
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="help" goto :show_help

REM 解析命令行参数
:parse_args
if "%1"=="" goto :start_monitor
if "%1"=="--interval" (
    set "MONITOR_INTERVAL=%2"
    shift
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
if "%1"=="--log-dir" (
    set "LOG_DIR=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--report" (
    call :generate_report
    exit /b 0
)
if "%1"=="--once" (
    set "RUN_ONCE=true"
    shift
    goto :parse_args
)
shift
goto :parse_args

:start_monitor
REM 创建必要目录
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" 2>nul
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%" 2>nul

REM 生成时间戳
for /f "tokens=1-6 delims=/:. " %%a in ('%SystemRoot%\System32\wbem\wmic.exe OS Get localdatetime ^| find "."') do (
    set "timestamp=%%a"
)
set "date_str=%timestamp:~0,8%"
set "time_str=%timestamp:~8,6%"
set "log_file=%LOG_DIR%\monitor_%date_str%.log"

echo 监控配置:
echo   应用地址: %APP_HOST%:%APP_PORT%
echo   管理端口: %MANAGEMENT_PORT%
echo   监控间隔: %MONITOR_INTERVAL% 秒
echo   日志目录: %LOG_DIR%
echo   日志文件: %log_file%
echo.

if defined RUN_ONCE (
    echo 执行单次监控检查...
    call :monitor_check
    exit /b 0
)

echo 开始持续监控... (按 Ctrl+C 停止)
echo.

REM 主监控循环
:monitor_loop
call :monitor_check

REM 清理旧日志
call :cleanup_logs

REM 等待下次检查
timeout /t %MONITOR_INTERVAL% /nobreak >nul 2>&1
goto :monitor_loop

REM ========================================
REM 执行监控检查
REM ========================================
:monitor_check
REM 生成当前时间戳
for /f "tokens=1-6 delims=/:. " %%a in ('%SystemRoot%\System32\wbem\wmic.exe OS Get localdatetime ^| find "."') do (
    set "current_time=%%a"
)
set "check_time=%current_time:~0,4%-%current_time:~4,2%-%current_time:~6,2% %current_time:~8,2%:%current_time:~10,2%:%current_time:~12,2%"

echo [%check_time%] 执行监控检查...
echo [%check_time%] ==================== 监控检查开始 ==================== >> "%log_file%"

REM 检查应用程序状态
call :check_application_status

REM 检查系统资源
call :check_system_resources

REM 检查磁盘空间
call :check_disk_usage

REM 检查网络连接
call :check_network_status

REM 检查错误日志
call :check_error_logs

echo [%check_time%] ==================== 监控检查结束 ==================== >> "%log_file%"
echo. >> "%log_file%"

echo   监控检查完成
exit /b 0

REM ========================================
REM 检查应用程序状态
REM ========================================
:check_application_status
echo   检查应用程序状态...

REM 检查应用端口
netstat -an | findstr ":%APP_PORT% " | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [%check_time%] [ERROR] 应用端口 %APP_PORT% 未监听 >> "%log_file%"
    call :send_alert "应用端口异常" "端口 %APP_PORT% 未监听"
) else (
    echo [%check_time%] [INFO] 应用端口 %APP_PORT% 正常 >> "%log_file%"
)

REM 检查健康检查端点
curl -s -f "http://%APP_HOST%:%MANAGEMENT_PORT%/actuator/health" >nul 2>&1
if errorlevel 1 (
    echo [%check_time%] [ERROR] 健康检查端点无响应 >> "%log_file%"
    call :send_alert "健康检查失败" "健康检查端点无响应"
) else (
    echo [%check_time%] [INFO] 健康检查端点正常 >> "%log_file%"
    
    REM 获取详细健康状态
    for /f "delims=" %%a in ('curl -s "http://%APP_HOST%:%MANAGEMENT_PORT%/actuator/health" 2^>nul') do (
        echo [%check_time%] [INFO] 健康状态: %%a >> "%log_file%"
    )
)

REM 检查响应时间
set "start_time=%time%"
curl -s -w "%%{time_total}" "http://%APP_HOST%:%APP_PORT%/api/health" -o nul 2>nul
set "end_time=%time%"
echo [%check_time%] [INFO] API响应时间检查完成 >> "%log_file%"

exit /b 0

REM ========================================
REM 检查系统资源
REM ========================================
:check_system_resources
echo   检查系统资源...

REM 检查CPU使用率
for /f "skip=1 tokens=2" %%a in ('wmic cpu get loadpercentage /value ^| findstr "="') do (
    set "cpu_usage=%%a"
)

if defined cpu_usage (
    echo [%check_time%] [INFO] CPU使用率: %cpu_usage%%% >> "%log_file%"
    if %cpu_usage% gtr %ALERT_THRESHOLD_CPU% (
        echo [%check_time%] [WARN] CPU使用率过高: %cpu_usage%%% >> "%log_file%"
        call :send_alert "CPU使用率告警" "CPU使用率: %cpu_usage%%%"
    )
)

REM 检查内存使用率
for /f "skip=1 tokens=2" %%a in ('wmic OS get TotalVisibleMemorySize /value ^| findstr "="') do (
    set "total_memory=%%a"
)
for /f "skip=1 tokens=2" %%a in ('wmic OS get FreePhysicalMemory /value ^| findstr "="') do (
    set "free_memory=%%a"
)

if defined total_memory if defined free_memory (
    set /a "memory_usage_percent=(total_memory-free_memory)*100/total_memory"
    echo [%check_time%] [INFO] 内存使用率: !memory_usage_percent!%% >> "%log_file%"
    
    if !memory_usage_percent! gtr %ALERT_THRESHOLD_MEMORY% (
        echo [%check_time%] [WARN] 内存使用率过高: !memory_usage_percent!%% >> "%log_file%"
        call :send_alert "内存使用率告警" "内存使用率: !memory_usage_percent!%%"
    )
)

REM 检查进程状态
tasklist | findstr "java.exe" >nul
if errorlevel 1 (
    echo [%check_time%] [WARN] 未找到Java进程 >> "%log_file%"
) else (
    echo [%check_time%] [INFO] Java进程运行正常 >> "%log_file%"
    
    REM 获取Java进程详细信息
    for /f "tokens=2,5" %%a in ('tasklist /fi "imagename eq java.exe" /fo table ^| findstr "java.exe"') do (
        echo [%check_time%] [INFO] Java进程 PID: %%a, 内存: %%b >> "%log_file%"
    )
)

exit /b 0

REM ========================================
REM 检查磁盘使用情况
REM ========================================
:check_disk_usage
echo   检查磁盘使用情况...

REM 获取磁盘使用情况
for /f "tokens=1,2,3,4" %%a in ('wmic logicaldisk get size^,freespace^,caption /value ^| findstr "="') do (
    if "%%a" neq "" (
        set "disk_info=%%a"
        if "!disk_info:~0,7!"=="Caption" (
            set "drive=!disk_info:~8!"
        )
        if "!disk_info:~0,9!"=="FreeSpace" (
            set "free_space=!disk_info:~10!"
        )
        if "!disk_info:~0,4!"=="Size" (
            set "total_space=!disk_info:~5!"
            if defined drive if defined free_space if defined total_space (
                set /a "disk_usage_percent=(total_space-free_space)*100/total_space"
                echo [%check_time%] [INFO] 磁盘 !drive! 使用率: !disk_usage_percent!%% >> "%log_file%"
                
                if !disk_usage_percent! gtr %ALERT_THRESHOLD_DISK% (
                    echo [%check_time%] [WARN] 磁盘 !drive! 使用率过高: !disk_usage_percent!%% >> "%log_file%"
                    call :send_alert "磁盘空间告警" "磁盘 !drive! 使用率: !disk_usage_percent!%%"
                )
                
                set "drive="
                set "free_space="
                set "total_space="
            )
        )
    )
)

exit /b 0

REM ========================================
REM 检查网络状态
REM ========================================
:check_network_status
echo   检查网络状态...

REM 检查网络连接数
for /f "tokens=1" %%a in ('netstat -an ^| findstr "ESTABLISHED" ^| find /c "ESTABLISHED"') do (
    set "established_connections=%%a"
)

echo [%check_time%] [INFO] 当前建立的连接数: %established_connections% >> "%log_file%"

REM 检查监听端口
for %%p in (%APP_PORT% %MANAGEMENT_PORT%) do (
    netstat -an | findstr ":%%p " | findstr "LISTENING" >nul
    if errorlevel 1 (
        echo [%check_time%] [ERROR] 端口 %%p 未监听 >> "%log_file%"
    ) else (
        echo [%check_time%] [INFO] 端口 %%p 正常监听 >> "%log_file%"
    )
)

exit /b 0

REM ========================================
REM 检查错误日志
REM ========================================
:check_error_logs
echo   检查错误日志...

REM 检查应用日志中的错误
set "app_log_dir=%~dp0..\logs"
if exist "%app_log_dir%\blog-system.log" (
    REM 查找最近的错误
    findstr /i "error\|exception\|failed" "%app_log_dir%\blog-system.log" | tail -5 >nul 2>&1
    if not errorlevel 1 (
        echo [%check_time%] [WARN] 发现应用错误日志 >> "%log_file%"
        for /f "delims=" %%a in ('findstr /i "error\|exception\|failed" "%app_log_dir%\blog-system.log" ^| tail -5') do (
            echo [%check_time%] [ERROR] %%a >> "%log_file%"
        )
    ) else (
        echo [%check_time%] [INFO] 应用日志正常 >> "%log_file%"
    )
) else (
    echo [%check_time%] [WARN] 应用日志文件不存在 >> "%log_file%"
)

exit /b 0

REM ========================================
REM 发送告警
REM ========================================
:send_alert
set "alert_title=%~1"
set "alert_message=%~2"

echo [%check_time%] [ALERT] %alert_title%: %alert_message% >> "%log_file%"

REM 这里可以添加邮件、短信或其他告警方式
REM 例如：发送邮件、调用API、写入事件日志等

REM 写入Windows事件日志
eventcreate /T WARNING /ID 1001 /L APPLICATION /SO "BlogSystem" /D "博客系统监控告警: %alert_title% - %alert_message%" >nul 2>&1

exit /b 0

REM ========================================
REM 清理旧日志
REM ========================================
:cleanup_logs
REM 删除超过保留天数的日志文件
forfiles /p "%LOG_DIR%" /m "monitor_*.log" /d -%MAX_LOG_FILES% /c "cmd /c del @path" >nul 2>&1
exit /b 0

REM ========================================
REM 生成监控报告
REM ========================================
:generate_report
echo 生成监控报告...

REM 生成时间戳
for /f "tokens=1-6 delims=/:. " %%a in ('%SystemRoot%\System32\wbem\wmic.exe OS Get localdatetime ^| find "."') do (
    set "timestamp=%%a"
)
set "report_file=%REPORT_DIR%\monitor_report_%timestamp:~0,8%_%timestamp:~8,6%.html"

REM 创建HTML报告
echo ^<!DOCTYPE html^> > "%report_file%"
echo ^<html^>^<head^>^<title^>博客系统监控报告^</title^>^</head^> >> "%report_file%"
echo ^<body^>^<h1^>博客系统监控报告^</h1^> >> "%report_file%"
echo ^<p^>生成时间: %timestamp:~0,4%-%timestamp:~4,2%-%timestamp:~6,2% %timestamp:~8,2%:%timestamp:~10,2%:%timestamp:~12,2%^</p^> >> "%report_file%"

REM 添加最近的监控日志
echo ^<h2^>最近监控日志^</h2^>^<pre^> >> "%report_file%"
if exist "%log_file%" (
    type "%log_file%" >> "%report_file%"
)
echo ^</pre^>^</body^>^</html^> >> "%report_file%"

echo 监控报告已生成: %report_file%
exit /b 0

REM ========================================
REM 显示帮助信息
REM ========================================
:show_help
echo.
echo 博客系统监控工具
echo.
echo 用法:
echo   monitor-system.bat [选项]
echo.
echo 选项:
echo   --interval SECONDS    监控间隔秒数 (默认: 60)
echo   --host HOST           应用主机地址 (默认: localhost)
echo   --app-port PORT       应用端口 (默认: 8080)
echo   --mgmt-port PORT      管理端口 (默认: 8081)
echo   --log-dir DIR         日志目录 (默认: ..\logs\monitor)
echo   --once                执行单次检查后退出
echo   --report              生成监控报告
echo   --help, -h            显示此帮助信息
echo.
echo 示例:
echo   # 开始持续监控
echo   monitor-system.bat
echo.
echo   # 自定义监控间隔
echo   monitor-system.bat --interval 30
echo.
echo   # 执行单次检查
echo   monitor-system.bat --once
echo.
echo   # 生成监控报告
echo   monitor-system.bat --report
echo.
echo 监控内容:
echo   - 应用程序状态和健康检查
echo   - 系统资源使用情况 (CPU、内存)
echo   - 磁盘空间使用情况
echo   - 网络连接状态
echo   - 错误日志检查
echo   - 自动告警和报告生成
echo.
exit /b 0