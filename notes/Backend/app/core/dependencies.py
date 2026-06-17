from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from app.core import JWT_Handler
from app.core.database import get_session
from app.repository import repo

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_session)):
    # added db: AsyncSession = Depends(get_db) — FastAPI resolves BOTH dependencies for us
    payload = JWT_Handler.verify_Token(token)
    username = payload.get("sub")
    if username is None or not isinstance(username, str):
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")

    user = await repo.get_by_username(db, username)
    # await + db passed in — same reason as everywhere else
    if user is None:
        raise HTTPException(status_code=401, detail="User no longer exists")
    return user