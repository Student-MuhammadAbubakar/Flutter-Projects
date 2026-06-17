from sqlmodel import SQLModel, Field
from pydantic import ConfigDict
from datetime import datetime
from typing import Optional

class Note(SQLModel, table=True):
    model_config = ConfigDict(frozen=False)
    id: Optional[int] = Field(primary_key=True)
    title: str
    content: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
    owner_id: Optional[int] = Field(default=None, foreign_key="user.id")

    