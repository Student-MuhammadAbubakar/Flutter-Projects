from sqlmodel import SQLModel
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from app.config import Settings 
from typing import Annotated
from fastapi import Depends
engine = create_async_engine(
    Settings.Postregres_URL(), 
    echo=True,
)
async def get_session():
    async_session=sessionmaker(
        bind=engine,
        class_=AsyncSession,
        expire_on_commit=False
    )
    async with async_session(bind=engine) as session:
        yield session
    
Session_dependency=Annotated[AsyncSession, Depends(get_session)]
async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)

