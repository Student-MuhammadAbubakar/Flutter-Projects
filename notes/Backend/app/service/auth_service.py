from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import UserCreate, login
from app.repository import repo
from app.core import security
from app.core import JWT_Handler

async def register(db: AsyncSession, data: UserCreate):
    if not data.username or not data.username.strip():
        raise HTTPException(status_code=400, detail="Username cannot be empty")
    if len(data.password) < 6:
        raise HTTPException(status_code=400, detail="Password must be at least 6 characters")

    existing_user = await repo.get_by_username(db, data.username)
    if existing_user:
        raise HTTPException(status_code=400, detail="Username already taken. Please choose another.")

    hashed = security.hash_password(data.password)
    user = await repo.create_user(db, data.username, hashed)
    return {"message": "Account created successfully", "username": user.username}

async def Login(db: AsyncSession, data: login):
    user = await repo.get_by_username(db, data.username)
    if user is None:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    password_match = security.verify_password(data.password, user.hashed_password)
    if not password_match:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = JWT_Handler.create_token({"sub": user.username})
    return {"access_token": token, "token_type": "bearer"}