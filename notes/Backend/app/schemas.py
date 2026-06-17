from pydantic import BaseModel
from datetime import datetime
from typing import Optional
class NoteCreate(BaseModel):
    title:str
    content:str
class NoteUpdate(BaseModel):
    title:Optional[str]=None
    content:Optional[str]=None
class NoteResponse(BaseModel):
    id:int
    title:str
    content:str
    created_at:datetime
class UserCreate(BaseModel):
    username:str
    password:str
class login(BaseModel):
    username:str
    password:str
# What server sends BACK after successful login
# Notice: NO password, NO hash — user never sees these
# Only the token they need for future requests
class TokenResponse(BaseModel):
    access_token: str
    token_type: str  # always "bearer"

# What server sends back after successful registration
# Simple confirmation message only
class RegisterResponse(BaseModel):
    message: str
    username: str
