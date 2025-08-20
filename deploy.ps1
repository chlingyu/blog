# Astro Blog Deployment Script
param(
    [string]$ServerIP = "159.75.167.181",
    [string]$Username = "root"
)

Write-Host "Starting deployment process..." -ForegroundColor Green

# Build the project
Write-Host "Building the project..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# Check if dist folder exists
if (-not (Test-Path "dist")) {
    Write-Host "Error: dist folder not found after build!" -ForegroundColor Red
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green

# Create deployment archive using 7-Zip or tar
Write-Host "Creating deployment archive..." -ForegroundColor Yellow
if (Get-Command tar -ErrorAction SilentlyContinue) {
    tar -czf blog-deploy.tar.gz -C dist .
} else {
    # Fallback: Create zip file if tar is not available
    Compress-Archive -Path "dist\*" -DestinationPath "blog-deploy.zip" -Force
    $archiveName = "blog-deploy.zip"
}

if ($LASTEXITCODE -ne 0 -and -not $archiveName) {
    Write-Host "Failed to create archive!" -ForegroundColor Red
    exit 1
}

$archiveFile = if ($archiveName) { $archiveName } else { "blog-deploy.tar.gz" }
Write-Host "Archive created successfully: $archiveFile" -ForegroundColor Green

# Upload to server
Write-Host "Uploading to server..." -ForegroundColor Yellow
scp $archiveFile "${Username}@${ServerIP}:/tmp/"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Upload failed!" -ForegroundColor Red
    Remove-Item $archiveFile -ErrorAction SilentlyContinue
    exit 1
}

Write-Host "Upload completed!" -ForegroundColor Green

# Deploy on server
Write-Host "Deploying on server..." -ForegroundColor Yellow
$extractCommand = if ($archiveFile -eq "blog-deploy.tar.gz") {
    "tar -xzf /tmp/$archiveFile -C /var/www/blog/"
} else {
    "cd /tmp && unzip -o $archiveFile -d /var/www/blog/"
}

$deployCommand = @"
$extractCommand && \
chown -R nginx:nginx /var/www/blog && \
systemctl reload nginx && \
rm /tmp/$archiveFile
"@

ssh "${Username}@${ServerIP}" $deployCommand
if ($LASTEXITCODE -ne 0) {
    Write-Host "Deployment failed!" -ForegroundColor Red
    Remove-Item $archiveFile -ErrorAction SilentlyContinue
    exit 1
}

# Clean up local archive
Remove-Item $archiveFile -ErrorAction SilentlyContinue

Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "Your blog is now live at: http://$ServerIP/blog/" -ForegroundColor Cyan