import os
import pathlib
import httpx
from fastapi import FastAPI, Request
from fastapi.responses import Response, HTMLResponse
from fastapi.staticfiles import StaticFiles

# Minimal FastAPI + proxy example
PROJECT_ID = "4950f334-daf9-487b-8328-b475644f0117"
UPSTREAM   = f"https://api.langflow.astra.datastax.com/lf/{PROJECT_ID}"
API_TOKEN  = os.getenv("ASTRA_API_TOKEN")

# Hop‑by‑hop headers (HTTP/1.1 §13.5.1) we never forward
HOP   = {b"connection", b"keep-alive", b"proxy-authenticate", b"proxy-authorization", b"te", b"trailers", b"transfer-encoding", b"upgrade"}

# Extra headers we strip so httpx can generate correct ones
STRIP = {b"authorization", b"host", b"content-type", b"content-length"}

app = FastAPI()

static_dir = pathlib.Path(__file__).parent / "static"
app.mount("/static", StaticFiles(directory=static_dir), name="static")

@app.get("/", response_class=HTMLResponse)
async def index():
    """Return ./static/index.html."""
    return (static_dir / "index.html").read_text()

@app.api_route("/proxy/{path:path}", methods=["GET", "POST", "PUT", "PATCH", "DELETE"])
async def proxy(path: str, request: Request):
    """Forward the incoming request to the Langflow Astra API."""

    # 1. Copy incoming headers, dropping hop‑by‑hop + STRIP
    upstream_headers = {
        k.decode(): v.decode(errors="replace")
        for k, v in request.headers.raw
        if k.lower() not in HOP and k.lower() not in STRIP
    }
    # 2. Add auth + single JSON content‑type
    upstream_headers["authorization"] = f"Bearer {API_TOKEN}"
    upstream_headers["content-type"] = "application/json"

    # 3. Send the request upstream
    url = f"{UPSTREAM}/{path}"
    async with httpx.AsyncClient(timeout=None) as client:
        upstream_resp = await client.request(
            request.method,
            url,
            params=dict(request.query_params),
            headers=upstream_headers,
            content=await request.body(),
        )

    # 4. Relay the response back, stripping hop‑by‑hop headers
    return Response(
        content=upstream_resp.content,
        status_code=upstream_resp.status_code,
        headers={k: v for k, v in upstream_resp.headers.items() if k.lower().encode() not in HOP},
    )