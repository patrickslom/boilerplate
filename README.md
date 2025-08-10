# Docker Fullstack Boilerplate

A clean starting point for any React + Node + Postgres project using Docker and Traefik.  
Purpose: give you a working stack with minimal code so you can start building features immediately.

## What this is
- React frontend (Vite) served by Nginx
- Node + Express backend
- Postgres database with a persisted volume
- Traefik routing for local development
- Matching production compose with Traefik TLS on a VPS

## What it is not
- It does not contain demo screens, business routes, or schema
- It does not create tables or seed data
- It does not lock you to any UI kit

## Assumptions
- You are on Windows with Docker Desktop using the Linux engine
- You are comfortable using Docker Compose
- You will use a container registry to push images for production
- You will run Traefik on your VPS

---

## Quick start (local)

1. Start Docker Desktop and ensure Linux engine is active.
2. From the project root run:
   ```sh
   docker compose -f docker-compose.local.yml up -d --build
   ```
3. Open:
   - Frontend: http://frontend.localhost
   - Backend health: http://backend.localhost/api/health
   - DB test: http://backend.localhost/api/db-test

If you see ok from health and db-test returns { db: "ok" }, the boilerplate is ready.

---

## Starting a new project from this boilerplate

Option A: clone and reuse directly
```sh
git clone https://github.com/you/docker-fullstack-boilerplate.git my-new-project
cd my-new-project
rm -rf .git
git init
git add .
git commit -m "Init my new project"
```

Option B: keep this as a template repo on GitHub
- Create a new repo named `docker-fullstack-boilerplate`
- Upload these files
- In GitHub, mark it as a template
- Use the green "Use this template" button for each new project

What to change first
- Package names in `frontend/package.json` and `backend/package.json`
- Update README title and description
- If you need API routes, add them in `backend/server.js`
- If you need DB migrations, add your tooling of choice

---

## Production deployment (VPS with Traefik TLS)

1. Build and tag images locally, then push to your registry:
   ```sh
   # login once
   docker login

   # frontend
   docker build -t boilerplate-frontend:latest ./frontend
   docker tag boilerplate-frontend:latest <registry>/<namespace>/boilerplate-frontend:latest
   docker push <registry>/<namespace>/boilerplate-frontend:latest

   # backend
   docker build -t boilerplate-backend:latest ./backend
   docker tag boilerplate-backend:latest <registry>/<namespace>/boilerplate-backend:latest
   docker push <registry>/<namespace>/boilerplate-backend:latest
   ```

2. On your VPS:
   - Copy the `prod/` folder to a directory on the server (for example `/root/boilerplate-prod`)
   - Set DNS A records for your domains to the VPS IP
   - Create and edit `prod/.env.prod` with your values
   - Create the ACME storage file:
     ```sh
     mkdir -p letsencrypt && touch letsencrypt/acme.json && chmod 600 letsencrypt/acme.json
     ```
   - Start:
     ```sh
     docker compose --env-file prod/.env.prod -f prod/docker-compose.prod.yml up -d
     ```

3. Verify HTTPS:
   - Frontend at your real domain from `.env.prod`
   - Backend health at your API domain from `.env.prod`

---

## Services overview

### Traefik (local)
- Listens on port 80
- Uses Docker provider
- Routes by Host rules:
  - `frontend.localhost` to the frontend container
  - `backend.localhost` to the backend container

### Frontend
- Built with Vite
- Served by Nginx in production mode
- No built-in calls to the API
- You control environment-specific API base URLs in your code when you add them

### Backend
- Express server exposes:
  - `GET /api/health` returns `{ ok: true }`
  - `GET /api/db-test` runs `SELECT 1` against Postgres and returns `{ db: "ok" }` on success
- No schema creation, no tables, no seed

### Database
- Postgres 15
- Named volume `pgdata` for persistence

---

## Local troubleshooting

- If Traefik cannot start, make sure Docker Desktop is running in Linux engine mode.
- If port 80 is busy, stop other services using it:
  - On Windows, disable IIS or stop W3SVC: `net stop w3svc`
- If `frontend.localhost` does not resolve, try a different browser or clear DNS cache.

---

## Evolving the boilerplate

- Add your preferred ORM and migrations (Prisma, Knex, Sequelize)
- Add logging, healthchecks, restart policies
- Add a `Makefile` or PowerShell scripts for common tasks
- Add GitHub Actions to build and push images automatically

This repository is meant to stay minimal and stable so you can start fast every time.
