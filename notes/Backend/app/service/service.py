from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import NoteCreate, NoteUpdate
from app.repository import repo


async def get_all_Note(db: AsyncSession):
    return await repo.get_all_Note(db)


async def get_Note(db: AsyncSession, id: int):
    note = await repo.get_one_Note(id, db)
    if note is None:
        raise HTTPException(status_code=404, detail="Note not found")
    return note


async def create_Note(db: AsyncSession, current_user, note: NoteCreate):
    if not note.title or not note.title.strip():
        raise HTTPException(status_code=400, detail="Title cannot be empty")
    if len(note.title) > 100:
        raise HTTPException(status_code=400, detail="Title is too long")
    return await repo.create_note(db, current_user.id, note)


async def delete(db: AsyncSession, id: int, current_user):
    # Step 1: Find the note FIRST — before doing anything
    note = await repo.get_one_Note(id, db)

    # Step 2: Does it even exist?
    if note is None:
        raise HTTPException(status_code=404, detail="Note not found")

    # Step 3: Does it belong to the person asking?
    # This check happens BEFORE delete — this is the fix
    if note.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="You can only delete your own notes")

    # Step 4: Only now — after both checks pass — actually delete
    await repo.delete_Note(db, id)
    return {"message": "Note deleted successfully"}


async def update_note(db: AsyncSession, id: int, current_user, data: NoteUpdate):
    # Step 1: Find the note FIRST — before changing anything
    note = await repo.get_one_Note(id, db)

    # Step 2: Does it even exist?
    if note is None:
        raise HTTPException(status_code=404, detail="Note not found")

    # Step 3: Does it belong to the person asking?
    # This check happens BEFORE update — this is the fix
    if note.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="You can only edit your own notes")

    # Step 4: Only now — after both checks pass — actually update
    updated_note = await repo.update_Note(db, id, data)
    return updated_note