@echo off
setlocal enabledelayedexpansion

set SERVICE_NAME=BlogSystemBackend

echo ========================================
echo   Blog System Backend Service Manager
echo ========================================
echo.
echo 1. Start Service
echo 2. Stop Service
echo 3. Restart Service
echo 4. Check Service Status
echo 5. View Service Logs
echo 6. Uninstall Service
echo 7. Exit
echo.
set /p choice=Please select an option (1-7): 

if "%choice%"=="1" goto start_service
if "%choice%"=="2" goto stop_service
if "%choice%"=="3" goto restart_service
if "%choice%"=="4" goto check_status
if "%choice%"=="5" goto view_logs
if "%choice%"=="6" goto uninstall_service
if "%choice%"=="7" goto exit

echo Invalid choice. Please try again.
pause
goto :eof

:start_service
echo Starting %SERVICE_NAME%...
nssm start %SERVICE_NAME%
if %ERRORLEVEL% equ 0 (
    echo Service started successfully!
) else (
    echo Failed to start service.
)
pause
goto :eof

:stop_service
echo Stopping %SERVICE_NAME%...
nssm stop %SERVICE_NAME%
if %ERRORLEVEL% equ 0 (
    echo Service stopped successfully!
) else (
    echo Failed to stop service.
)
pause
goto :eof

:restart_service
echo Restarting %SERVICE_NAME%...
nssm restart %SERVICE_NAME%
if %ERRORLEVEL% equ 0 (
    echo Service restarted successfully!
) else (
    echo Failed to restart service.
)
pause
goto :eof

:check_status
echo Checking %SERVICE_NAME% status...
nssm status %SERVICE_NAME%
echo.
sc query %SERVICE_NAME%
pause
goto :eof

:view_logs
echo Recent logs from %SERVICE_NAME%:
echo.
if exist "logs\service-stdout.log" (
    echo === STDOUT LOG ===
    powershell "Get-Content 'logs\service-stdout.log' -Tail 20"
    echo.
)
if exist "logs\service-stderr.log" (
    echo === STDERR LOG ===
    powershell "Get-Content 'logs\service-stderr.log' -Tail 20"
    echo.
)
if exist "logs\blog-system.log" (
    echo === APPLICATION LOG ===
    powershell "Get-Content 'logs\blog-system.log' -Tail 20"
)
pause
goto :eof

:uninstall_service
echo WARNING: This will completely remove the %SERVICE_NAME% service.
set /p confirm=Are you sure? (y/N): 
if /i "%confirm%"=="y" (
    echo Stopping and removing %SERVICE_NAME%...
    nssm stop %SERVICE_NAME%
    nssm remove %SERVICE_NAME% confirm
    echo Service uninstalled successfully!
) else (
    echo Operation cancelled.
)
pause
goto :eof

:exit
exit /b 0