from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.dependencies import get_current_user
from app.core.database import get_session
from app.schemas import NoteCreate, NoteUpdate
from app.service import service

router = APIRouter()

@router.get("/notes")
async def get_all_Notes(db: AsyncSession = Depends(get_session)):
    # Depends(get_db) = "FastAPI, please open a session for me and close it when I'm done"
    return await service.get_all_Note(db)

@router.get("/notes/{id}")
async def get_byId(id: int, db: AsyncSession = Depends(get_session)):
    return await service.get_Note(db, id)

@router.post("/notes")
async def create(data: NoteCreate, db: AsyncSession = Depends(get_session), current_user=Depends(get_current_user)):
    return await service.create_Note(db,current_user, data)

@router.delete("/notes/{id}")
async def delete(id: int, db: AsyncSession = Depends(get_session), current_user=Depends(get_current_user)):
    return await service.delete(db, id,current_user)

@router.put("/notes/{id}")
async def update(id: int, data: NoteUpdate, db: AsyncSession = Depends(get_session), current_user=Depends(get_current_user)):
    return await service.update_note(db, id, current_user, data)