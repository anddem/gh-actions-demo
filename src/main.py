from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    """
    endpoint - /

    Default "Hello, world" endpoint
    """
    return {"message": "Hello, user!"}
