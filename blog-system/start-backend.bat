@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo    博客系统后端生产模式启动脚本
echo ========================================
echo.

:: 检查JAVA_HOME
if "%JAVA_HOME%"=="" (
    echo [错误] 未设置 JAVA_HOME 环境变量！
    echo 请先安装 Java 21+ 并设置 JAVA_HOME
    pause
    exit /b 1
)

:: 检查Java版本
echo [信息] 检查Java版本...
"%JAVA_HOME%\bin\java" -version 2>&1 | findstr "version"
if %errorLevel% neq 0 (
    echo [错误] Java 未正确安装或配置！
    pause
    exit /b 1
)

:: 检查端口占用
echo [信息] 检查端口占用情况...
netstat -an | findstr ":8080" >nul
if %errorLevel% equ 0 (
    echo [警告] 端口 8080 已被占用！
    echo 请检查是否有其他应用使用此端口
    set /p continue=是否继续启动？(y/N): 
    if /i not "!continue!"=="y" (
        echo [信息] 启动已取消
        pause
        exit /b 1
    )
)

netstat -an | findstr ":8081" >nul
if %errorLevel% equ 0 (
    echo [警告] 端口 8081 已被占用！
    echo 请检查是否有其他应用使用此端口
)

:: 创建必要目录
echo [信息] 创建必要目录...
if not exist "logs" mkdir logs
if not exist "uploads" mkdir uploads
if not exist "uploads\avatars" mkdir "uploads\avatars"
if not exist "uploads\articles" mkdir "uploads\articles"
if not exist "uploads\comments" mkdir "uploads\comments"

:: 检查是否需要构建
set "BUILD_NEEDED=0"
if not exist "target" set "BUILD_NEEDED=1"
if not exist "target\*.jar" set "BUILD_NEEDED=1"

if "!BUILD_NEEDED!"=="1" (
    echo [信息] 检测到需要构建项目...
    echo 开始构建项目，这可能需要几分钟时间...
    call mvnw.cmd clean package -DskipTests
    if !errorLevel! neq 0 (
        echo [错误] 项目构建失败！
        pause
        exit /b 1
    )
    echo [成功] 项目构建完成！
)

:: 查找JAR文件
set "JAR_FILE="
for %%f in (target\*.jar) do (
    if not "%%~nf"=="%%~nf.original" (
        set "JAR_FILE=%%f"
    )
)

if "%JAR_FILE%"=="" (
    echo [错误] 未找到构建的JAR文件！
    echo 请先运行: mvnw clean package -DskipTests
    pause
    exit /b 1
)

echo [信息] 找到JAR文件: %JAR_FILE%

:: 设置JVM参数
set "JVM_OPTS=-Xms512m -Xmx1024m"
set "JVM_OPTS=%JVM_OPTS% -XX:+UseG1GC"
set "JVM_OPTS=%JVM_OPTS% -XX:+UseStringDeduplication"
set "JVM_OPTS=%JVM_OPTS% -XX:+PrintGCDetails"
set "JVM_OPTS=%JVM_OPTS% -XX:+PrintGCTimeStamps"
set "JVM_OPTS=%JVM_OPTS% -Xloggc:logs/gc.log"
set "JVM_OPTS=%JVM_OPTS% -Dspring.profiles.active=prod"
set "JVM_OPTS=%JVM_OPTS% -Dfile.encoding=UTF-8"
set "JVM_OPTS=%JVM_OPTS% -Duser.timezone=Asia/Shanghai"

echo.
echo ========================================
echo 启动配置信息:
echo ========================================
echo JAR文件: %JAR_FILE%
echo 配置文件: application-prod.yml
echo JVM参数: %JVM_OPTS%
echo 主端口: 8080
echo 管理端口: 8081
echo 日志目录: logs/
echo 上传目录: uploads/
echo ========================================
echo.

echo [信息] 启动博客系统后端服务...
echo [提示] 按 Ctrl+C 可停止服务
echo [提示] 服务启动后可访问:
echo          - 健康检查: http://localhost:8081/actuator/health
echo          - API文档: http://localhost:8080/swagger-ui.html
echo          - 应用信息: http://localhost:8081/actuator/info
echo.

:: 启动应用
"%JAVA_HOME%\bin\java" %JVM_OPTS% -jar "%JAR_FILE%"

:: 检查退出状态
if %errorLevel% neq 0 (
    echo.
    echo [错误] 应用启动失败！退出代码: %errorLevel%
    echo 请检查:
    echo 1. 数据库连接是否正常
    echo 2. 配置文件是否正确
    echo 3. 端口是否被占用
    echo 4. 查看日志文件: logs/blog-system.log
    echo.
    pause
)

echo.
echo [信息] 博客系统后端服务已停止
pause