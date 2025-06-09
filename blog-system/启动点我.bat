@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo          Blog System Launcher
echo ========================================
echo.

echo [1] Starting MySQL80 service...
net start MySQL80 >nul 2>&1
if errorlevel 1 (
    echo MySQL80 service may already be running, checking status...
    sc query MySQL80 | find "RUNNING" >nul
    if errorlevel 1 (
        echo MySQL service start failed, please check MySQL installation
        pause
        exit /b 1
    )
)
echo MySQL service is running

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully
echo ========================================
echo.
echo Backend API: http://localhost:8080
echo Frontend: http://localhost:5173
echo Admin Panel: http://localhost:5173/admin
echo.
echo Default Admin Account:
echo Username: admin
echo Password: admin123
echo.
echo Press any key to exit...
pause >nul

echo.
echo [2] Testing database connection...
mysql -u root -p123456 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo Database connection failed, please check MySQL credentials
    pause
    exit /b 1
)
echo Database connection successful

echo.
echo [3] Building backend...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo Backend build failed
    pause
    exit /b 1
)
echo Backend build successful

echo.
echo [4] Installing frontend dependencies...
cd frontend
if not exist node_modules (
    call npm install
    if errorlevel 1 (
        echo Frontend dependencies installation failed
        pause
        exit /b 1
    )
)
cd ..
echo Frontend dependencies ready

echo.
echo [5] Starting services...
echo Starting backend service...
start "Backend" cmd /c "java -jar target\blog-system-0.0.1-SNAPSHOT.jar"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo Starting frontend service...
cd frontend
start "Frontend" cmd /c "npm run dev"
cd ..

echo.
echo ========================================
echo        Services Started Successfully