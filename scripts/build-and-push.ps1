param(
    [string]$DockerUser = "your-dockerhub-username",
    [string]$ProjectName = "myapp"
)

$Commit = git rev-parse --short HEAD

Write-Host "Building and pushing frontend image..." -ForegroundColor Cyan
docker build -t $ProjectName-frontend:latest ./frontend
docker tag $ProjectName-frontend:latest "$DockerUser/$ProjectName-frontend:$Commit"
docker tag $ProjectName-frontend:latest "$DockerUser/$ProjectName-frontend:latest"
docker push "$DockerUser/$ProjectName-frontend:$Commit"
docker push "$DockerUser/$ProjectName-frontend:latest"

Write-Host "Building and pushing backend image..." -ForegroundColor Cyan
docker build -t $ProjectName-backend:latest ./backend
docker tag $ProjectName-backend:latest "$DockerUser/$ProjectName-backend:$Commit"
docker tag $ProjectName-backend:latest "$DockerUser/$ProjectName-backend:latest"
docker push "$DockerUser/$ProjectName-backend:$Commit"
docker push "$DockerUser/$ProjectName-backend:latest"

Write-Host "Build and push complete!" -ForegroundColor Green
