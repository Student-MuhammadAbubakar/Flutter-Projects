from sqlmodel import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import NoteCreate,NoteUpdate
from app.model import Note
from app.User_model import User
async def get_all_Note(db:AsyncSession):
    result = await db.execute(select(Note))
    return list(result.scalars().all())
async def get_one_Note(id:int,db:AsyncSession):
    
        result = await db.execute(select(Note).where(Note.id == id))
    # .where() is the SQL WHERE clause — replaces your old "for note in mynote: if note.id==id"
        return result.scalar_one_or_none()
async def create_note(db: AsyncSession,owner_id:int, note: NoteCreate):
    new_note = Note(title=note.title,owner_id=owner_id, content=note.content)
    # no more counter["id"] += 1 — Postgres assigns the id automatically
    db.add(new_note)
    # add() stages the new row (like mynote.append, but not saved yet)
    await db.commit()
    # commit() actually writes it to Postgres permanently
    await db.refresh(new_note)
    # refresh() pulls the auto-generated id/created_at back into the object
    return new_note

async def update_Note(db: AsyncSession, id: int, note: NoteUpdate):
    db_note = await get_one_Note(id, db)
    if db_note is None:
        return None
    if note.title is not None:
        db_note.title = note.title
    if note.content is not None:
        db_note.content = note.content
    db.add(db_note)
    # re-adding a modified object marks it "dirty" so commit knows to UPDATE it
    await db.commit()
    await db.refresh(db_note)
    return db_note

async def delete_Note(db: AsyncSession, id: int):
    db_note = await get_one_Note(id, db)
    if db_note is None:
        return False
    await db.delete(db_note)
    # delete() stages a DELETE statement for this row
    await db.commit()
    return True

async def get_by_username(db: AsyncSession, username: str):
    result = await db.execute(select(User).where(User.username == username))
    return result.scalar_one_or_none()

async def create_user(db: AsyncSession, username: str, hashed_password: str):
    new_user = User(username=username, hashed_password=hashed_password)
    # no more user_counter — Postgres handles the id
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return new_user