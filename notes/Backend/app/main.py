from fastapi import FastAPI
from app.router.router import router
app=FastAPI()
app.include_router(router)
@app.get("/")
def root():
    return {"message": "The Api is Running"}
