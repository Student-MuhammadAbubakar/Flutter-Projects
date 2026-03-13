from fastapi import FastAPI, HTTPException
from app.schema import BookCreate, BookUpdate
from app.database import Database

from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For development only – restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

db = Database()


@app.get("/books")
def Get_Books():
    books = db.GetBook()
    if not books:
        raise HTTPException(status_code=404, detail="Book not found")
    return books


@app.post("/books")
def Add_Book(book: BookCreate):
    book_id = db.CreateBook(book)
    return {"book_id": book_id}


@app.patch("/books/{id}")
def Update_Book(id: int, books: BookUpdate):
    db.UpdateBook(id, books)
    return {"message": "Book updated successfully"}


@app.get("/search")
def Search_Books(title: str):
    book = db.Search_get(title)
    if not book:
        raise HTTPException(status_code=404, detail="Book not found")
    return book


@app.get("/analytics")
def Analytics():
    return db.GetAnalytics()