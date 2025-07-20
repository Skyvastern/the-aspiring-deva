import uvicorn
from fastapi import FastAPI
from src.routes.ai import router as ai_router
from mangum import Mangum


app = FastAPI()
handler = Mangum(app)


@app.get("/")
def read_root():
    return {"Hello": "World"}


app.include_router(ai_router)


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, log_level="info", reload=True)