from fastapi import HTTPException
from app.schemas import NoteCreate, NoteUpdate
from app.repository import repo
def get_all_Note():
    return repo.get_all_Note()
def get_Note(id:int):
    note=repo.get_one_Note(id)
    if note is None:
        raise HTTPException(status_code=404,detail="Note not found"
        )
    return note
def create_Note(note: NoteCreate):
    if not note.title or not note.title.strip():
        raise HTTPException(status_code=400, detail="Title cannot be empty")
    if len(note.title) > 100:
        raise HTTPException(status_code=400, detail="Title is too long")
    return repo.create_note(note)
def delete(id):
    deleted=repo.delete_Note(id=id)
    if not deleted:
        raise HTTPException(status_code=404,detail="Note not found")
def update_note(id: int, data: NoteUpdate):
    note = repo.update_Note(id, data)
    if note is None:
        raise HTTPException(status_code=404, detail="Note not found")
    return note