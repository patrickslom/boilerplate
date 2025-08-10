Here’s how you can run them without editing the script each time — you just pass your Docker Hub username, project name, VPS IP, and project directory as parameters.

Build & push
From your project root:

ps1
Copy
Edit
.\scripts\build-and-push.ps1 -DockerUser "patrykslom87" -ProjectName "myapp"
This will:

Tag & push patrykslom87/myapp-frontend and patrykslom87/myapp-backend

Tag both latest and your current git commit SHA

Push both tags to Docker Hub

Deploy to VPS
From your project root:

ps1
Copy
Edit
.\scripts\deploy.ps1 -Server "root@123.45.67.89" -ProjectDir "/root/myapp"
This will:

SSH into your VPS

Pull the latest images defined in .env.prod

Restart containers in detached mode using docker-compose.prod.yml