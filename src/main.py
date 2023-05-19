import uvicorn
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def app_root():
    return ""


def run():
    uvicorn.run("src.main:app", host='127.0.0.1', port=8000, reload=True)

