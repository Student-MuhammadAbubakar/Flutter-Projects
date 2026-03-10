from pydantic import BaseModel
from enum import Enum

class BookStatus(str, Enum):
    in_progress = "in_progress"
    completed = "completed"
    un_read = "un_read"
class BookCreate(BaseModel):
    title: str
    author: str
    Total_pages: int
    pages_read: int
    status: BookStatus
class BookUpdate(BaseModel):
    pages_read: int
    status: BookStatus