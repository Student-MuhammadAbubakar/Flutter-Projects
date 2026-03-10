import sqlite3
from typing import Any
from app.schema import BookCreate,BookUpdate


class Database:
    def __init__(self):
        self.conn = sqlite3.connect("database.db", check_same_thread=False)
        self.cur = self.conn.cursor()
        self.create_table("Books")

    def create_table(self, name):
        self.cur.execute(
            f"""CREATE TABLE IF NOT EXISTS {name} (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            Total_pages INTEGER NOT NULL,
            pages_read INTEGER NOT NULL,
            status TEXT NOT NULL
        )""",
          
        )
        self.conn.commit()

    def CreateBook(self, Books: BookCreate):
        self.cur.execute("""SELECT MAX(id) FROM Books""")
        max_id = self.cur.fetchone()
        book_id = max_id[0] + 1 if max_id else 1
        self.cur.execute(
            """INSERT INTO Books (id, title, author, Total_pages, pages_read, status) 
            VALUES (:id, :title, :author, :Total_pages, :pages_read, :status)""",
            {"id": book_id,
            **Books.model_dump(), 
            },
        )
        self.conn.commit()
        return book_id
    def GetBook(self)->list[dict[str,Any]]:
        self.cur.execute("""SELECT * FROM Books""")
        row = self.cur.fetchall()
        if not row:
           return []
        books = []
        for row in row:
            books.append({
                "id": row[0],
                "title": row[1],
                "author": row[2],
                "total_pages": row[3],
                "pages_read": row[4],
                "status": row[5]
            })
        return books
    def Search_get(self, title:str)->dict[str,Any]:
        self.cur.execute("""SELECT * FROM Books WHERE title = ?""", (title,))
        row = self.cur.fetchone()
        return{
            "Title":row[1],
            "Author":row[2],
            "Total_pages":row[3],
            "Reading_Pages":row[4],
            "Status":row[5]
        }
    def UpdateBook(self, book_id:int, books:BookUpdate):
        self.cur.execute(
            """UPDATE Books SET pages_read = ?, status = ? WHERE id = ?""",
            (books.pages_read, books.status, book_id),
        )
        self.conn.commit()
    def DeleteBook(self, book_id:int):
        self.cur.execute("""DELETE FROM Books WHERE id = ?""", (book_id,))
        self.conn.commit()
    def GetAnalytics(self) -> dict[str, int]:
        self.cur.execute("SELECT COUNT(*) FROM Books")
        total_books = self.cur.fetchone()[0]
        self.cur.execute("SELECT COUNT(*) FROM Books WHERE status = 'in_progress'")
        reading_books = self.cur.fetchone()[0]
        self.cur.execute("SELECT COUNT(*) FROM Books WHERE status = 'completed'")
        completed_books = self.cur.fetchone()[0]
        self.cur.execute("SELECT COUNT(*) FROM Books WHERE status = 'un_read'")
        unread_books = self.cur.fetchone()[0]

        return {
            "total_books": total_books,
            "reading_books": reading_books,
            "completed_books": completed_books,
            "unread_books": unread_books
        }