@echo off
chcp 65001 >nul

REM 切换到docker目录
cd /d "%~dp0"

:menu
echo ========================================
echo        Docker Blog System Launcher
echo ========================================
echo Current directory: %CD%
echo ========================================
echo 1. Start All Services (Full Stack)
echo 2. Start Database Only
echo 3. Start Backend Only
echo 4. Start Frontend Only
echo 5. Build All Images
echo 6. View Logs
echo 7. Stop All Services
echo 8. Clean Up (Remove containers and images)
echo 9. Exit
echo ========================================
set /p choice=Please select (1-9): 

if "%choice%"=="1" goto start_all
if "%choice%"=="2" goto start_database
if "%choice%"=="3" goto start_backend
if "%choice%"=="4" goto start_frontend
if "%choice%"=="5" goto build_images
if "%choice%"=="6" goto view_logs
if "%choice%"=="7" goto stop_all
if "%choice%"=="8" goto cleanup
if "%choice%"=="9" goto exit_script

echo Invalid choice, please try again.
pause
goto menu

:start_all
echo Starting all services with Docker Compose...
docker-compose up -d
if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================
    echo All services started successfully!
    echo ========================================
    echo Database: MySQL (localhost:3306)
    echo Backend: http://localhost:8080
    echo Frontend: http://localhost:3000
    echo Admin: http://localhost:3000/admin
    echo ========================================
    echo Default Admin: admin / admin123
    echo ========================================
    echo Use 'docker-compose logs -f' to view logs
) else (
    echo Failed to start services. Please check Docker and try again.
)
pause
goto menu

:start_database
echo Starting database service...
docker-compose up -d mysql
if %ERRORLEVEL% equ 0 (
    echo Database service started successfully!
    echo MySQL is available at localhost:3306
) else (
    echo Failed to start database service.
)
pause
goto menu

:start_backend
echo Starting backend service...
docker-compose up -d mysql blog-backend
if %ERRORLEVEL% equ 0 (
    echo Backend service started successfully!
    echo Backend API is available at http://localhost:8080
) else (
    echo Failed to start backend service.
)
pause
goto menu

:start_frontend
echo Starting frontend service...
docker-compose up -d blog-frontend
if %ERRORLEVEL% equ 0 (
    echo Frontend service started successfully!
    echo Frontend is available at http://localhost:3000
) else (
    echo Failed to start frontend service.
)
pause
goto menu

:build_images
echo Building all Docker images...
docker-compose build --no-cache
if %ERRORLEVEL% equ 0 (
    echo All images built successfully!
) else (
    echo Failed to build images.
)
pause
goto menu

:view_logs
echo ========================================
echo Available services for log viewing:
echo ========================================
echo 1. All services
echo 2. Backend only
echo 3. Frontend only
echo 4. Database only
echo 5. Back to main menu
echo ========================================
set /p log_choice=Please select (1-5): 

if "%log_choice%"=="1" (
    echo Viewing logs for all services (Press Ctrl+C to exit)...
    docker-compose logs -f
) else if "%log_choice%"=="2" (
    echo Viewing backend logs (Press Ctrl+C to exit)...
    docker-compose logs -f blog-backend
) else if "%log_choice%"=="3" (
    echo Viewing frontend logs (Press Ctrl+C to exit)...
    docker-compose logs -f blog-frontend
) else if "%log_choice%"=="4" (
    echo Viewing database logs (Press Ctrl+C to exit)...
    docker-compose logs -f mysql
) else if "%log_choice%"=="5" (
    goto menu
) else (
    echo Invalid choice.
    pause
)
goto menu

:stop_all
echo Stopping all services...
docker-compose down
if %ERRORLEVEL% equ 0 (
    echo All services stopped successfully!
) else (
    echo Failed to stop services.
)
pause
goto menu

:cleanup
echo WARNING: This will remove all containers, images, and volumes!
set /p confirm=Are you sure? (y/N): 
if /i "%confirm%"=="y" (
    echo Stopping and removing all containers...
    docker-compose down -v
    echo Removing images...
    docker-compose down --rmi all
    echo Cleanup completed!
) else (
    echo Operation cancelled.
)
pause
goto menu

:exit_script
echo Exiting...
exit /b 0