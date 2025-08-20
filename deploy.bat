@echo off
echo =======================================
echo   部署 Astro 博客到 CentOS 服务器
echo =======================================

REM 服务器信息
set SERVER=159.75.167.181
set USER=root
set REMOTE_PATH=/var/www/blog

echo.
echo [1/4] 构建项目...
call npm run build
if errorlevel 1 (
    echo 构建失败！请检查错误信息
    pause
    exit /b 1
)

echo.
echo [2/4] 创建部署包...
cd dist
tar -czf ../deploy.tar.gz *
cd ..

echo.
echo [3/4] 上传到服务器...
echo 需要输入服务器密码：
scp deploy.tar.gz %USER%@%SERVER%:/tmp/

echo.
echo [4/4] 在服务器上解压部署...
ssh %USER%@%SERVER% "rm -rf %REMOTE_PATH%/* && tar -xzf /tmp/deploy.tar.gz -C %REMOTE_PATH% && chown -R nginx:nginx %REMOTE_PATH% && rm /tmp/deploy.tar.gz"

echo.
echo =======================================
echo   部署完成！
echo   访问: http://%SERVER%/blog/
echo =======================================

REM 清理本地临时文件
del deploy.tar.gz

pause