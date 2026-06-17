from jose import jwt,JWTError #type:ignore
from datetime import datetime, timedelta
from fastapi import HTTPException
import os
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))
def create_token(data: dict) -> str:
    
    payload = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=EXPIRE_MINUTES)
    payload.update({"exp": expire})
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    
    return token
def verify_Token(token:str)->dict:
   try: 
       payload=jwt.decode(token,SECRET_KEY,ALGORITHM)
       Username:str=payload.get("sub")
       if Username is None:
           raise HTTPException(statuscode=401,detail="Not found")
       return payload
   except JWTError:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token. Please login again."
        )