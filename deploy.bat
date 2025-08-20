@echo off
chcp 65001 >nul
echo =======================================
echo   Deploy Astro Blog to CentOS Server
echo =======================================

REM Server Configuration
set SERVER=159.75.167.181
set USER=root
set REMOTE_PATH=/var/www/blog

echo.
echo [1/4] Building project...
call npm run build
if errorlevel 1 (
    echo Build failed! Please check error messages
    pause
    exit /b 1
)

echo.
echo [2/4] Creating deployment package...
cd dist
tar -czf ../deploy.tar.gz *
cd ..

echo.
echo [3/4] Uploading to server...
echo Please enter server password:
scp deploy.tar.gz %USER%@%SERVER%:/tmp/

echo.
echo [4/4] Extracting on server...
ssh %USER%@%SERVER% "mkdir -p %REMOTE_PATH% && rm -rf %REMOTE_PATH%/* && tar -xzf /tmp/deploy.tar.gz -C %REMOTE_PATH% && chown -R nginx:nginx %REMOTE_PATH% && rm /tmp/deploy.tar.gz"

echo.
echo =======================================
echo   Deployment Complete!
echo   Visit: http://%SERVER%/blog/
echo =======================================

REM Clean up temporary files
del deploy.tar.gz

pause