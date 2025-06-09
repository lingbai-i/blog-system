@echo off
chcp 65001 >nul

:menu
echo ========================================
echo           Blog System Launcher
echo ========================================
echo 1. Full Start (Database + Backend + Frontend)
echo 2. Start Backend Only
echo 3. Start Frontend Only
echo 4. Build Project
echo 5. Test API
echo 6. Database Management
echo 7. Stop All Services
echo 8. Exit
echo ========================================
set /p choice=Please select (1-8): 

if "%choice%"=="1" goto full_start
if "%choice%"=="2" goto start_backend
if "%choice%"=="3" goto start_frontend
if "%choice%"=="4" goto build_project
if "%choice%"=="5" goto test_api
if "%choice%"=="6" goto database_menu
if "%choice%"=="7" goto stop_services
if "%choice%"=="8" goto exit_script

echo Invalid choice, please try again.
pause
goto menu

:full_start
echo Starting full deployment...

REM Check and start MySQL service
echo [1/4] Checking MySQL service...
call :check_mysql
if %ERRORLEVEL% neq 0 (
    echo MySQL service check failed!
    pause
    goto menu
)

echo [2/4] Building backend...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Backend build failed!
    pause
    goto menu
)

echo [3/4] Starting backend service...
start "Blog Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 15 /nobreak >nul

echo [4/4] Starting frontend service...
cd frontend
if not exist node_modules (
    echo Installing frontend dependencies...
    npm install
)
start "Blog Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo Startup Complete!
echo ========================================
echo Database: MySQL (localhost:3306/blog_system)
echo Backend: http://localhost:8080
echo Frontend: http://localhost:3000
echo Admin: http://localhost:3000/admin
echo ========================================
echo Default Admin: admin / admin123
echo ========================================
pause
goto menu

:start_backend
echo Starting backend only...

REM Check MySQL service
echo Checking MySQL service...
call :check_mysql
if %ERRORLEVEL% neq 0 (
    echo MySQL service check failed!
    pause
    goto menu
)

echo Building backend...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Backend build failed!
    pause
    goto menu
)

echo Starting backend service...
java -jar target\blog-system-0.0.1-SNAPSHOT.jar
pause
goto menu

:start_frontend
echo Starting frontend only...
cd frontend
if not exist node_modules (
    npm install
)
npm run dev
cd ..
pause
goto menu

:build_project
echo Building project...
echo Building backend...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Backend build failed!
    pause
    goto menu
)

echo Building frontend...
cd frontend
if not exist node_modules (
    npm install
)
npm run build
cd ..
echo Build complete!
pause
goto menu

:test_api
echo ========================================
echo Testing API Endpoints...
echo ========================================

echo [1/5] Testing Announcements API...
curl -s -o nul -w "Announcements API: %%{http_code}\n" http://localhost:8080/api/announcements/published

echo [2/5] Testing Blogs API...
curl -s -o nul -w "Blogs API: %%{http_code}\n" http://localhost:8080/api/blogs

echo [3/5] Testing Categories API...
curl -s -o nul -w "Categories API: %%{http_code}\n" http://localhost:8080/api/categories

echo [4/5] Testing Tags API...
curl -s -o nul -w "Tags API: %%{http_code}\n" http://localhost:8080/api/tags

echo [5/5] Testing System Stats API...
curl -s -o nul -w "System Stats API: %%{http_code}\n" http://localhost:8080/api/system/stats

echo.
echo ========================================
echo API Response Details:
echo ========================================

echo Testing Announcements (sample data)...
curl -X GET "http://localhost:8080/api/announcements/published" -H "Content-Type: application/json"
echo.
echo.

echo Testing Blogs (first page)...
curl -X GET "http://localhost:8080/api/blogs?page=0&size=3" -H "Content-Type: application/json"
echo.
echo.

echo Testing Categories...
curl -X GET "http://localhost:8080/api/categories" -H "Content-Type: application/json"
echo.
echo.

pause
goto menu

:database_menu
echo ========================================
echo         Database Management
echo ========================================
echo 1. Check MySQL Status
echo 2. Start MySQL Service
echo 3. Stop MySQL Service
echo 4. Create Database
echo 5. Reset Database
echo 6. Back to Main Menu
echo ========================================
set /p db_choice=Please select (1-6): 

if "%db_choice%"=="1" goto check_mysql_status
if "%db_choice%"=="2" goto start_mysql
if "%db_choice%"=="3" goto stop_mysql
if "%db_choice%"=="4" goto create_database
if "%db_choice%"=="5" goto reset_database
if "%db_choice%"=="6" goto menu

echo Invalid choice, please try again.
pause
goto database_menu

:check_mysql_status
echo Checking MySQL service status...
sc query mysql >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo MySQL service is running.
) else (
    echo MySQL service is not running.
)
pause
goto database_menu

:start_mysql
echo Starting MySQL service...
net start mysql >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo MySQL service started successfully.
) else (
    echo Failed to start MySQL service. Please check if MySQL is installed.
)
pause
goto database_menu

:stop_mysql
echo Stopping MySQL service...
net stop mysql >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo MySQL service stopped successfully.
) else (
    echo Failed to stop MySQL service.
)
pause
goto database_menu

:create_database
echo Creating blog_system database...
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS blog_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
if %ERRORLEVEL% equ 0 (
    echo Database created successfully.
) else (
    echo Failed to create database. Please check MySQL connection.
)
pause
goto database_menu

:reset_database
echo WARNING: This will delete all data in blog_system database!
set /p confirm=Are you sure? (y/N): 
if /i "%confirm%"=="y" (
    echo Resetting database...
    mysql -u root -p -e "DROP DATABASE IF EXISTS blog_system; CREATE DATABASE blog_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    if %ERRORLEVEL% equ 0 (
        echo Database reset successfully.
    ) else (
        echo Failed to reset database.
    )
) else (
    echo Operation cancelled.
)
pause
goto database_menu

:stop_services
echo Stopping all services...
echo Stopping Java processes...
taskkill /f /im java.exe >nul 2>&1
echo Stopping Node.js processes...
taskkill /f /im node.exe >nul 2>&1
echo All application services stopped.
echo Note: MySQL service is still running. Use Database Management to stop it if needed.
pause
goto menu

:check_mysql
REM Check if MySQL service is running
sc query mysql >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo MySQL service is not running. Attempting to start...
    net start mysql >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo Failed to start MySQL service.
        echo Please ensure MySQL is installed and configured properly.
        echo You can:
        echo 1. Install MySQL Server
        echo 2. Start MySQL service manually
        echo 3. Use Database Management menu (option 6)
        exit /b 1
    )
    echo MySQL service started successfully.
) else (
    echo MySQL service is running.
)

REM Test database connection
echo Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Database connection test failed.
    echo Please check:
    echo 1. MySQL username/password (current: root/123456)
    echo 2. Database configuration in application-dev.properties
    echo 3. Create blog_system database if it doesn't exist
    exit /b 1
)
echo Database connection successful.
exit /b 0

:exit_script
echo Exiting...
exit /b 0