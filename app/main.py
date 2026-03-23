from fastapi import FastAPI
from fastapi.responses import JSONResponse
import os

app = FastAPI(title="API Service", version="1.0.0")


@app.get("/")
def root():
    return {"status": "ok", "version": os.getenv("APP_VERSION", "dev")}


@app.get("/health")
def health():
    return JSONResponse(
        status_code=200,
        content={"healthy": True}
    )
