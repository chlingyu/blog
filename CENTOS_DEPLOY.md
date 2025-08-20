# CentOS 7.6 完整部署步骤

## 🚀 服务器端操作（SSH 登录后依次执行）

### 第一步：系统更新和基础软件安装
```bash
# 1. 更新系统
sudo yum update -y

# 2. 安装 EPEL 仓库
sudo yum install -y epel-release

# 3. 安装必要工具
sudo yum install -y wget curl git vim nano
```

### 第二步：安装 Node.js（用于后续可能的服务端渲染）
```bash
# 4. 安装 Node.js 16.x
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# 5. 验证安装
node --version
npm --version
```

### 第三步：安装和配置 Nginx
```bash
# 6. 安装 Nginx
sudo yum install -y nginx

# 7. 启动 Nginx 并设置开机自启
sudo systemctl start nginx
sudo systemctl enable nginx

# 8. 配置防火墙
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 第四步：创建网站目录
```bash
# 9. 创建博客目录
sudo mkdir -p /var/www/blog

# 10. 设置权限
sudo chown -R nginx:nginx /var/www/blog
sudo chmod -R 755 /var/www/blog
```

### 第五步：配置 Nginx
```bash
# 11. 创建 Nginx 配置文件
sudo nano /etc/nginx/conf.d/blog.conf
```

**粘贴以下内容（已在 nginx-blog.conf 文件中）：**
```nginx
server {
    listen 80;
    server_name 159.75.167.181;
    
    location /blog {
        alias /var/www/blog;
        index index.html;
        try_files $uri $uri/ /blog/index.html;
        
        gzip on;
        gzip_vary on;
        gzip_min_length 1024;
        gzip_types text/plain text/css text/xml text/javascript application/json application/javascript application/xml+rss application/rss+xml application/atom+xml image/svg+xml text/javascript application/x-javascript application/x-font-ttf application/vnd.ms-fontobject font/opentype;
    }
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

保存退出：`Ctrl+X`，然后 `Y`，再按 `Enter`

```bash
# 12. 测试 Nginx 配置
sudo nginx -t

# 13. 重载 Nginx
sudo systemctl reload nginx
```

### 第六步：SELinux 配置（如果启用）
```bash
# 14. 检查 SELinux 状态
getenforce

# 15. 如果是 Enforcing，设置权限
sudo setsebool -P httpd_can_network_connect 1
sudo chcon -Rt httpd_sys_content_t /var/www/blog
```

## 💻 本地 Windows 操作

### 第一次部署：
```bash
# 1. 打开命令提示符或 PowerShell
# 2. 进入项目目录
cd D:\blog

# 3. 运行部署脚本
deploy.bat
```

### 后续更新：
只需运行 `deploy.bat` 即可

## ✅ 验证部署

### 在服务器上检查：
```bash
# 检查文件是否上传
ls -la /var/www/blog/

# 检查 Nginx 状态
sudo systemctl status nginx

# 查看 Nginx 错误日志（如有问题）
sudo tail -f /var/log/nginx/error.log
```

### 在浏览器访问：
```
http://159.75.167.181/blog/
```

## 🔧 故障排除

### 1. 如果网站无法访问：
```bash
# 检查防火墙
sudo firewall-cmd --list-all

# 检查 Nginx 是否运行
sudo systemctl status nginx

# 检查端口是否监听
sudo netstat -tlnp | grep :80
```

### 2. 如果出现 403 错误：
```bash
# 检查文件权限
sudo chown -R nginx:nginx /var/www/blog
sudo chmod -R 755 /var/www/blog

# 检查 SELinux
sudo setenforce 0  # 临时禁用测试
```

### 3. 如果部署脚本失败：
- 确保安装了 Git Bash（Windows）
- 确保 SSH 可以连接到服务器
- 检查服务器密码是否正确

## 📝 一键部署总结

1. **服务器初始化**（只需一次）：
   - 复制上面的命令 1-15，在 SSH 中执行

2. **部署博客**：
   - 在 Windows 运行 `deploy.bat`
   - 输入服务器密码
   - 等待部署完成

3. **访问博客**：
   - http://159.75.167.181/blog/

就这么简单！