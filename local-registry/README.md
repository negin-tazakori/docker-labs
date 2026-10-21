# Local Registry with Basic Authentication

A local Docker registry using basic authentication (htpasswd). Official images
(nginx, mariadb, alpine) are pulled from Docker Hub, pushed to this registry,
and can then be pulled back from it locally.

## Architecture

```
Docker client ──(docker login / push / pull)──► registry:3 (port 5000)
                                                  │
                                    ┌─────────────┴─────────────┐
                              auth/htpasswd              registry-data (volume)
                           (user credentials)             (stored images)
```

## Prerequisites

- Docker and Docker Compose
- htpasswd (package `apache2-utils` on Debian/Ubuntu)

## Setup

### 1. Create the htpasswd file

```bash
mkdir -p auth
htpasswd -Bn username > auth/htpasswd
```
> Use your own username and a strong password. The file is excluded via `.gitignore`.

### 2. Start the registry

```bash
docker compose up -d
docker ps
```

### 3. Log in

```bash
docker login localhost:5000
```

### 4. Push the images

```bash
chmod +x push-images.sh
./push-images.sh
```
