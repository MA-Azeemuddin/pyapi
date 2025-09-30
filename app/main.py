from fastapi import FastAPI
from fastapi.responses import FileResponse
import uvicorn

app = FastAPI()

@app.get("/")
def read_root():
    return {"running locally"}

@app.get("/api")
def read_api():
    return {"message": "Hello from API ver.1.1.0"}

@app.get("/health")
def read_health():
    return {"status": "healthy"}

@app.get("/favicon.ico")
def favicon():
    return FileResponse("favicon.ico")




def main():
    uvicorn.run(app, host="0.0.0.0", port=3030)


if __name__ == "__main__":
    main()
