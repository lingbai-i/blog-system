@echo off
echo Installing Blog System Backend as Windows Service...
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator!
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Download NSSM if not exists
if not exist "nssm.exe" (
    echo NSSM not found. Please download NSSM from https://nssm.cc/download
    echo Extract nssm.exe to this directory and run this script again.
    pause
    exit /b 1
)

REM Set variables
set SERVICE_NAME=BlogSystemBackend
set JAVA_HOME_PATH=%JAVA_HOME%
if "%JAVA_HOME_PATH%"=="" (
    echo JAVA_HOME is not set. Please set JAVA_HOME environment variable.
    pause
    exit /b 1
)

set JAR_PATH=%~dp0target\blog-system-0.0.1-SNAPSHOT.jar
set JAVA_EXE=%JAVA_HOME_PATH%\bin\java.exe

REM Build the project first
echo Building project...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

REM Stop service if exists
echo Stopping existing service...
nssm stop %SERVICE_NAME% >nul 2>&1
nssm remove %SERVICE_NAME% confirm >nul 2>&1

REM Install service
echo Installing service...
nssm install %SERVICE_NAME% "%JAVA_EXE%"
nssm set %SERVICE_NAME% Arguments "-jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod \"%JAR_PATH%\""
nssm set %SERVICE_NAME% DisplayName "Blog System Backend Service"
nssm set %SERVICE_NAME% Description "Blog System Backend Spring Boot Application"
nssm set %SERVICE_NAME% Start SERVICE_AUTO_START
nssm set %SERVICE_NAME% AppDirectory "%~dp0"
nssm set %SERVICE_NAME% AppStdout "%~dp0logs\service-stdout.log"
nssm set %SERVICE_NAME% AppStderr "%~dp0logs\service-stderr.log"
nssm set %SERVICE_NAME% AppRotateFiles 1
nssm set %SERVICE_NAME% AppRotateOnline 1
nssm set %SERVICE_NAME% AppRotateSeconds 86400
nssm set %SERVICE_NAME% AppRotateBytes 10485760

REM Create logs directory
if not exist "logs" mkdir logs

REM Start service
echo Starting service...
nssm start %SERVICE_NAME%

echo.
echo Service installed successfully!
echo Service Name: %SERVICE_NAME%
echo You can manage the service using:
echo   - Services.msc (Windows Services Manager)
echo   - nssm start %SERVICE_NAME%
echo   - nssm stop %SERVICE_NAME%
echo   - nssm restart %SERVICE_NAME%
echo   - nssm remove %SERVICE_NAME% confirm
echo.
pause