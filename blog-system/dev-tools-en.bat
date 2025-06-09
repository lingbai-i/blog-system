@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo       Blog System Development Tools
echo ========================================
echo.

:menu
echo Please select an option:
echo [1] Reset Database
echo [2] Clean Build Cache
echo [3] Check System Status
echo [4] View System Logs
echo [5] Performance Monitor
echo [6] Backup Database
echo [7] Generate API Documentation
echo [8] Format Code
echo [0] Exit
echo.
set /p choice="Enter your choice (0-8): "

if "%choice%"=="1" goto reset_db
if "%choice%"=="2" goto clean_cache
if "%choice%"=="3" goto check_status
if "%choice%"=="4" goto view_logs
if "%choice%"=="5" goto performance_monitor
if "%choice%"=="6" goto backup_db
if "%choice%"=="7" goto generate_docs
if "%choice%"=="8" goto format_code
if "%choice%"=="0" goto exit

echo Invalid choice, please try again.
echo.
goto menu

:reset_db
echo ========================================
echo           Resetting Database
echo ========================================
echo.
echo Warning: This will delete all existing data!
set /p confirm="Are you sure? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    goto menu
)

echo Stopping backend service...
taskkill /f /im java.exe 2>nul

echo Resetting database...
mysql -u root -p blog_system < src\main\resources\schema.sql
if %errorlevel% equ 0 (
    echo Database reset successfully!
) else (
    echo Database reset failed!
)
echo.
pause
goto menu

:clean_cache
echo ========================================
echo         Cleaning Build Cache
echo ========================================
echo.
echo Cleaning Maven cache...
if exist target rmdir /s /q target
if exist .mvn\.m2 rmdir /s /q .mvn\.m2

echo Cleaning frontend cache...
cd frontend
if exist node_modules rmdir /s /q node_modules
if exist dist rmdir /s /q dist
cd ..

echo Cleaning logs...
if exist logs\*.log del /q logs\*.log
if exist logs\*.gz del /q logs\*.gz

echo Cache cleaned successfully!
echo.
pause
goto menu

:check_status
echo ========================================
echo         Checking System Status
echo ========================================
echo.
echo Checking Java version...
java -version
echo.

echo Checking Maven version...
mvn -version
echo.

echo Checking Node.js version...
node -v
echo.

echo Checking npm version...
npm -v
echo.

echo Checking MySQL connection...
mysql -u root -p -e "SELECT 'MySQL connection successful' as status;"
echo.

echo Checking port usage...
netstat -ano | findstr :8080
netstat -ano | findstr :3000
echo.

echo Checking running Java processes...
tasklist | findstr java.exe
echo.
pause
goto menu

:view_logs
echo ========================================
echo          Viewing System Logs
echo ========================================
echo.
echo Recent application logs:
if exist logs\blog-system.log (
    echo Last 20 lines of application log:
    powershell "Get-Content logs\blog-system.log -Tail 20"
) else (
    echo No application logs found.
)
echo.

echo Recent error logs:
if exist logs\error.log (
    echo Last 10 lines of error log:
    powershell "Get-Content logs\error.log -Tail 10"
) else (
    echo No error logs found.
)
echo.
pause
goto menu

:performance_monitor
echo ========================================
echo         Performance Monitor
echo ========================================
echo.
echo System resource usage:
echo.
echo CPU and Memory usage:
wmic cpu get loadpercentage /value
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /value
echo.

echo Disk usage:
wmic logicaldisk get size,freespace,caption
echo.

echo Java process memory usage:
for /f "tokens=1,2" %%a in ('tasklist /fi "imagename eq java.exe" /fo csv ^| findstr java') do (
    echo Process: %%a, Memory: %%b
)
echo.
pause
goto menu

:backup_db
echo ========================================
echo          Database Backup
echo ========================================
echo.
set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
set backup_file=backup\blog_system_%timestamp%.sql

if not exist backup mkdir backup

echo Creating database backup...
mysqldump -u root -p blog_system > %backup_file%
if %errorlevel% equ 0 (
    echo Database backup created: %backup_file%
) else (
    echo Database backup failed!
)
echo.
pause
goto menu

:generate_docs
echo ========================================
echo       Generating API Documentation
echo ========================================
echo.
echo Generating Swagger documentation...
cd .
echo Starting application to generate docs...
start /b mvn spring-boot:run -Dspring-boot.run.profiles=dev
echo.
echo Waiting for application to start...
timeout /t 30 /nobreak
echo.
echo API documentation should be available at:
echo http://localhost:8080/swagger-ui.html
echo.
echo Press any key to stop the application...
pause
taskkill /f /im java.exe 2>nul
goto menu

:format_code
echo ========================================
echo           Code Formatting
echo ========================================
echo.
echo Formatting Java code...
if exist pom.xml (
    mvn spotless:apply
    if %errorlevel% equ 0 (
        echo Java code formatted successfully!
    ) else (
        echo Java code formatting failed!
    )
) else (
    echo No Maven project found.
)
echo.

echo Formatting frontend code...
cd frontend
if exist package.json (
    npm run format 2>nul
    if %errorlevel% equ 0 (
        echo Frontend code formatted successfully!
    ) else (
        echo Frontend code formatting failed or no format script found.
    )
) else (
    echo No frontend project found.
)
cd ..
echo.
pause
goto menu

:exit
echo.
echo Thank you for using Blog System Development Tools!
echo.
pause
exit /b 0