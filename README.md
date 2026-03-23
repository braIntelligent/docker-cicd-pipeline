# Docker CI/CD Pipeline

Automated Docker image build, test, and push pipeline using GitHub Actions.

## Pipeline

```
PR opened          →  CI: build + health test + Trivy scan
Merge to main      →  CI + CD: push to Docker Hub  (tags: main, sha-xxxxxxx, latest)
Tag v1.2.3 pushed  →  CI + CD: push to Docker Hub  (tags: 1.2.3, 1.2, 1, latest)
```

## Local development

```bash
# Build and run locally
docker compose up --build

# Test endpoints
curl http://localhost:8000/
curl http://localhost:8000/health
```

## Pipeline secrets required

| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token (not password) |

## Key practices

- **Multi-stage build** — builder stage installs deps, runtime stage is minimal
- **Non-root user** — container runs as `appuser` (uid 1001), not root
- **Health check** — Docker and pipeline both verify the container responds
- **Trivy scan** — checks for known CVEs in the final image
- **Multi-platform** — builds for `linux/amd64` and `linux/arm64`
- **Layer caching** — `cache-from/to: gha` reuses layers between pipeline runs
- **Semantic versioning** — tags generated automatically from git tags

## Author

Matías Cataldo — [GitHub](https://github.com/braIntelligent)
