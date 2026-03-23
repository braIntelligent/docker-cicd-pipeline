# ── Stage 1: builder ──────────────────────────────────────
# Instala dependencias en una imagen temporal
FROM python:3.12-slim AS builder

WORKDIR /app

# Copiar solo requirements primero — aprovecha cache de Docker
# Si requirements.txt no cambia, esta capa no se reconstruye
COPY app/requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt


# ── Stage 2: runtime ──────────────────────────────────────
# Imagen final mínima — sin herramientas de build
FROM python:3.12-slim AS runtime

# Non-root user — buena práctica de seguridad
RUN groupadd --gid 1001 appgroup && \
    useradd --uid 1001 --gid appgroup --shell /bin/sh --create-home appuser

WORKDIR /app

# Copiar dependencias instaladas desde builder
COPY --from=builder /install /usr/local

# Copiar código fuente
COPY --chown=appuser:appgroup app/ .

# Variable de entorno — se sobreescribe en runtime
ENV APP_VERSION=1.0.0

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
