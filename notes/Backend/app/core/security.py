from passlib.context import CryptContext #type:ignore

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password[:72])       # ← truncate to 72 bytes

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain[:72], hashed) # ← truncate here too