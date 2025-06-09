@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo    博客系统后端服务管理工具
echo ========================================
echo.

:: 检查NSSM
if not exist "nssm.exe" (
    echo [错误] 未找到 nssm.exe 文件！
    echo 请从 https://nssm.cc/download 下载 NSSM 并将 nssm.exe 放在项目根目录
    pause
    exit /b 1
)

:MENU
cls
echo ========================================
echo    博客系统后端服务管理工具
echo ========================================
echo.
echo 请选择操作:
echo.
echo [1] 启动服务
echo [2] 停止服务
echo [3] 重启服务
echo [4] 查看服务状态
echo [5] 查看服务日志
echo [6] 卸载服务
echo [7] 重新安装服务
echo [8] 服务配置信息
echo [0] 退出
echo.
set /p choice=请输入选项 (0-8): 

if "%choice%"=="1" goto START_SERVICE
if "%choice%"=="2" goto STOP_SERVICE
if "%choice%"=="3" goto RESTART_SERVICE
if "%choice%"=="4" goto STATUS_SERVICE
if "%choice%"=="5" goto VIEW_LOGS
if "%choice%"=="6" goto REMOVE_SERVICE
if "%choice%"=="7" goto REINSTALL_SERVICE
if "%choice%"=="8" goto SERVICE_INFO
if "%choice%"=="0" goto EXIT

echo [错误] 无效选项，请重新选择！
pause
goto MENU

:START_SERVICE
echo.
echo [信息] 启动服务...
nssm start BlogSystemBackend
if %errorLevel% equ 0 (
    echo [成功] 服务启动成功！
) else (
    echo [错误] 服务启动失败！
)
echo.
pause
goto MENU

:STOP_SERVICE
echo.
echo [信息] 停止服务...
nssm stop BlogSystemBackend
if %errorLevel% equ 0 (
    echo [成功] 服务停止成功！
) else (
    echo [错误] 服务停止失败！
)
echo.
pause
goto MENU

:RESTART_SERVICE
echo.
echo [信息] 重启服务...
nssm restart BlogSystemBackend
if %errorLevel% equ 0 (
    echo [成功] 服务重启成功！
) else (
    echo [错误] 服务重启失败！
)
echo.
pause
goto MENU

:STATUS_SERVICE
echo.
echo [信息] 查看服务状态...
echo.
nssm status BlogSystemBackend
echo.
echo 详细状态信息:
sc query BlogSystemBackend
echo.
pause
goto MENU

:VIEW_LOGS
echo.
echo [信息] 查看服务日志...
echo.
echo 选择要查看的日志:
echo [1] 标准输出日志 (service-stdout.log)
echo [2] 错误日志 (service-stderr.log)
echo [3] 应用日志 (blog-system.log)
echo [4] 返回主菜单
echo.
set /p log_choice=请选择 (1-4): 

if "%log_choice%"=="1" (
    if exist "logs\service-stdout.log" (
        echo.
        echo === 标准输出日志 (最后50行) ===
        powershell "Get-Content 'logs\service-stdout.log' -Tail 50"
    ) else (
        echo [信息] 标准输出日志文件不存在
    )
)
if "%log_choice%"=="2" (
    if exist "logs\service-stderr.log" (
        echo.
        echo === 错误日志 (最后50行) ===
        powershell "Get-Content 'logs\service-stderr.log' -Tail 50"
    ) else (
        echo [信息] 错误日志文件不存在
    )
)
if "%log_choice%"=="3" (
    if exist "logs\blog-system.log" (
        echo.
        echo === 应用日志 (最后50行) ===
        powershell "Get-Content 'logs\blog-system.log' -Tail 50"
    ) else (
        echo [信息] 应用日志文件不存在
    )
)
if "%log_choice%"=="4" goto MENU

echo.
pause
goto MENU

:REMOVE_SERVICE
echo.
echo [警告] 即将卸载博客系统后端服务！
echo 这将停止并删除 Windows 服务，但不会删除应用文件。
echo.
set /p confirm=确认卸载服务？(y/N): 
if /i not "%confirm%"=="y" (
    echo [信息] 操作已取消
    pause
    goto MENU
)

echo.
echo [信息] 停止服务...
nssm stop BlogSystemBackend
echo [信息] 卸载服务...
nssm remove BlogSystemBackend confirm
if %errorLevel% equ 0 (
    echo [成功] 服务卸载成功！
) else (
    echo [错误] 服务卸载失败！
)
echo.
pause
goto MENU

:REINSTALL_SERVICE
echo.
echo [信息] 重新安装服务...
echo 这将先卸载现有服务，然后重新安装。
echo.
set /p confirm=确认重新安装？(y/N): 
if /i not "%confirm%"=="y" (
    echo [信息] 操作已取消
    pause
    goto MENU
)

echo.
echo [信息] 停止并卸载现有服务...
nssm stop BlogSystemBackend >nul 2>&1
nssm remove BlogSystemBackend confirm >nul 2>&1

echo [信息] 调用安装脚本...
call install-service.bat
echo.
pause
goto MENU

:SERVICE_INFO
echo.
echo [信息] 服务配置信息...
echo.
echo === 服务基本信息 ===
nssm get BlogSystemBackend Application
nssm get BlogSystemBackend Parameters
nssm get BlogSystemBackend AppDirectory
echo.
echo === 服务属性 ===
nssm get BlogSystemBackend DisplayName
nssm get BlogSystemBackend Description
nssm get BlogSystemBackend Start
echo.
echo === 日志配置 ===
nssm get BlogSystemBackend AppStdout
nssm get BlogSystemBackend AppStderr
echo.
echo === 健康检查 ===
echo 应用端口: 8080
echo 管理端口: 8081
echo 健康检查: http://localhost:8081/actuator/health
echo.
pause
goto MENU

:EXIT
echo.
echo 感谢使用博客系统服务管理工具！
echo.
exit /b 0