param(
    [string]$Server = "root@your-vps-ip",
    [string]$ProjectDir = "/root/myapp"
)

Write-Host "Deploying latest images to VPS..." -ForegroundColor Cyan
ssh $Server "cd $ProjectDir && docker compose --env-file .env.prod -f docker-compose.prod.yml pull && docker compose --env-file .env.prod -f docker-compose.prod.yml up -d"
Write-Host "Deployment complete!" -ForegroundColor Green
