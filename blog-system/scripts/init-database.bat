@echo off
chcp 65001 >nul

echo ========================================
echo      Database Initialization Script
echo ========================================

REM Check if MySQL is running
echo [1/4] Checking MySQL service...
sc query mysql >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo MySQL service is not running. Starting...
    net start mysql >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Failed to start MySQL service.
        echo Please install MySQL Server first.
        pause
        exit /b 1
    )
    echo MySQL service started successfully.
) else (
    echo MySQL service is running.
)

REM Create database
echo [2/4] Creating database...
mysql -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS blog_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to create database. Please check MySQL credentials.
    echo Current settings: username=root, password=123456
    pause
    exit /b 1
)
echo Database 'blog_system' created successfully.

REM Import schema
echo [3/4] Importing database schema...
if exist "src\main\resources\schema.sql" (
    mysql -u root -p123456 blog_system < "src\main\resources\schema.sql" 2>nul
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Failed to import schema.
        pause
        exit /b 1
    )
    echo Schema imported successfully.
) else (
    echo WARNING: schema.sql not found, skipping schema import.
)

REM Import initial data
echo [4/4] Importing initial data...
if exist "src\main\resources\data.sql" (
    mysql -u root -p123456 blog_system < "src\main\resources\data.sql" 2>nul
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Failed to import initial data.
        pause
        exit /b 1
    )
    echo Initial data imported successfully.
) else (
    echo WARNING: data.sql not found, skipping data import.
)

echo.
echo ========================================
echo Database initialization completed!
echo ========================================
echo Database: blog_system
echo Host: localhost:3306
echo Username: root
echo Password: 123456
echo ========================================
echo Default accounts will be created on first backend startup:
echo - Admin: admin / admin123
echo - User: user / user123
echo ========================================

pause