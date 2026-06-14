from app.schemas import NoteCreate,NoteUpdate
from app.model import Note
mynote:list[Note]=[]
counter={"id":0}
def get_all_Note():
    return mynote
def get_one_Note(id:int):
    for note in mynote:
        if note.id==id:
            return note
def create_note(note:NoteCreate):
    counter["id"]+=1
    new_note=Note(id=counter["id"],title=note.title,content=note.content)
    mynote.append(new_note)
    return new_note
def update_Note(id: int, note: NoteUpdate):
    for n in mynote:
        if n.id==id:
            if note.title is not None:
                n.title=note.title
            if note.content is not None:
                n.content=note.content
            return n
def delete_Note(id:int):
    for n in mynote:
        if n.id==id:
            mynote.remove(n)
            return True
    return False
