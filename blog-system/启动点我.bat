@echo off
chcp 65001 >nul

:menu
echo ========================================
echo           Blog System Launcher
echo ========================================
echo 1. Full Start (Build + Backend + Frontend)
echo 2. Start Backend Only
echo 3. Start Frontend Only
echo 4. Build Project
echo 5. Test API
echo 6. Stop All Services
echo 7. Exit
echo ========================================
set /p choice=Please select (1-7): 

if "%choice%"=="1" goto full_start
if "%choice%"=="2" goto start_backend
if "%choice%"=="3" goto start_frontend
if "%choice%"=="4" goto build_project
if "%choice%"=="5" goto test_api
if "%choice%"=="6" goto stop_services
if "%choice%"=="7" goto exit_script

echo Invalid choice, please try again.
pause
goto menu

:full_start
echo Starting full deployment...
echo Building backend...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Backend build failed!
    pause
    goto menu
)

echo Starting backend service...
start "Blog Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
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
echo Backend: http://localhost:8080
echo Frontend: http://localhost:3000
echo Admin: http://localhost:3000/admin
echo ========================================
pause
goto menu

:start_backend
echo Starting backend only...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Backend build failed!
    pause
    goto menu
)
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

:stop_services
echo Stopping all services...
taskkill /f /im java.exe >nul 2>&1
taskkill /f /im node.exe >nul 2>&1
echo All services stopped.
pause
goto menu

:exit_script
echo Exiting...
exit /b 0