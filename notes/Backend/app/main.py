from contextlib import asynccontextmanager
from fastapi import FastAPI
from dotenv import load_dotenv
from app.router.router import router as notes_router
from app.router.auth_router import router as auth_router
from app.core.database import init_db

load_dotenv()

@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    # runs once when the server starts — creates "note" and "user" tables if missing
    yield

app = FastAPI(lifespan=lifespan)

app.include_router(notes_router)
app.include_router(auth_router)

@app.get("/")
def root():
    return {"message": "Notes API is running", "docs": "/docs"}