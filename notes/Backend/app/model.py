from pydantic import BaseModel, ConfigDict, Field
from datetime import datetime

class Note(BaseModel):
    model_config = ConfigDict(frozen=False)
    id:int 
    title:str
    content:str
    created_at:datetime=Field(default_factory=datetime.now)

    