from fastapi import APIRouter
from app.schemas import NoteCreate, NoteUpdate
from app.service import service
router=APIRouter()
@router.get("/notes")
def get_all_Notes():
    return service.get_all_Note()
@router.get("/notes/{id}")
def get_byId(id: int):
    return service.get_Note(id)
@router.post("/notes")
def create(data: NoteCreate):
    return service.create_Note(data)
@router.delete("/notes/{id}")
def delete(id: int):
    return service.delete(id)
@router.put("/notes/{id}")
def update(id: int, data: NoteUpdate):
    return service.update_note(id, data)