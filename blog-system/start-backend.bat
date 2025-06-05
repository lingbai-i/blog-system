@echo off
echo Starting Blog System Backend...
echo.

REM Set JAVA_HOME if not set
if "%JAVA_HOME%"=="" (
    echo Warning: JAVA_HOME is not set. Using system java.
    set JAVA_CMD=java
) else (
    set JAVA_CMD="%JAVA_HOME%\bin\java"
)

REM Build the project first
echo Building project...
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

REM Start the application
echo Starting application...
%JAVA_CMD% -jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod target\blog-system-0.0.1-SNAPSHOT.jar

echo Backend stopped.
pause