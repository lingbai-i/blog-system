@echo off
chcp 65001 >nul

echo ========================================
echo      博客系统快速启动
echo ========================================
echo.
echo 正在启动博客系统...
echo.

REM 检查Java环境
if "%JAVA_HOME%"=="" (
    echo 警告: JAVA_HOME 未设置，使用系统Java。
    set JAVA_CMD=java
) else (
    set JAVA_CMD="%JAVA_HOME%\bin\java"
)

REM 构建后端
echo [1/4] 构建后端项目...
call mvn clean package -DskipTests -q
if %ERRORLEVEL% neq 0 (
    echo 后端构建失败！
    pause
    exit /b 1
)

REM 启动后端
echo [2/4] 启动后端服务...
start "博客系统后端" cmd /c "%JAVA_CMD% -jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod target\blog-system-0.0.1-SNAPSHOT.jar"

REM 等待后端启动
echo [3/4] 等待后端服务启动...
timeout /t 15 /nobreak >nul

REM 启动前端
echo [4/4] 启动前端服务...
cd frontend
if not exist node_modules (
    echo 安装前端依赖...
    npm install -q
)
start "博客系统前端" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo 启动完成！
echo ========================================
echo 后端地址: http://localhost:8080
echo 前端地址: http://localhost:3000
echo 管理后台: http://localhost:3000/admin
echo.
echo 默认管理员账号: admin / admin123
echo ========================================
echo.
echo 按任意键测试连接...
pause >nul

REM 测试连接
echo 测试后端连接...
curl -s -o nul -w "后端状态: HTTP %%{http_code}\n" http://localhost:8080/api/announcements
echo.
echo 系统已就绪！按任意键退出...
pause >nul