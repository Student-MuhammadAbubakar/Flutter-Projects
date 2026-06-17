from sqlmodel import SQLModel,Field
from pydantic import ConfigDict
from typing import Optional 
model_config=ConfigDict(frozen=True)
class User(SQLModel,table=True):
    id:Optional[int]=Field(default=None,primary_key=True)
    username:str=Field(unique=True, index=True)
    hashed_password:str