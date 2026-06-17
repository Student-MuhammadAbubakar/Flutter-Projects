from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import UserCreate, login
from app.service import auth_service
from app.core.database import get_session

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/register", status_code=201)
async def register(data: UserCreate, db: AsyncSession = Depends(get_session)):
    return await auth_service.register(db, data)

@router.post("/login")
async def login_route(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_session)):
    data = login(username=form_data.username, password=form_data.password)
    # ↑ NO await here — this is just creating a Pydantic object, not calling async code
    return await auth_service.Login(db, data)
    # ↑ await HERE — because auth_service.Login is the async function