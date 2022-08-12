from fastapi import FastAPI, Depends
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import desc
import models
from database import engine, SessionLocal
from fastapi.security import OAuth2PasswordBearer

api_keys = [
    "oOQLuUBPq1ZfeZxXO3TJo0Y3E3iB0btrC0JoiySl3udlapBXKnr99pMxtM5TTal8"
]

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


def api_key_auth(api_key: str = Depends(oauth2_scheme)):
    if api_key not in api_keys:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Forbidden"
        )


app = FastAPI()

models.Base.metadata.create_all(bind=engine)


class Announcement(BaseModel):
    start_date: str
    end_date: str
    deparment: str
    municipality: str
    description: str
    note_number: str
    type: str


def get_db():
    try:
        db = SessionLocal()
        yield db
    finally:
        db.close()


@app.get("/",  dependencies=[Depends(api_key_auth)])
def get_all_announcement(db=Depends(get_db)):
    return db.query(models.Announcement).order_by(
        desc(models.Announcement.id)
    ).all()


@app.get("/latest", dependencies=[Depends(api_key_auth)])
def get_latest_announcement_by_department(department: str, id: int, db=Depends(get_db)):
    return db.query(models.Announcement).order_by(
        desc(models.Announcement.id)
    ).filter(models.Announcement.department == department, models.Announcement.id > id).all()


@app.get("/count")
def get_item_count(department: Optional[str] = None, db=Depends(get_db)):
    if department is not None:
        return db.query(models.Announcement).filter(models.Announcement.department == department).count()
    return db.query(models.Announcement).count()


@app.get("/{department}", dependencies=[Depends(api_key_auth)])
def get_announcement_by_department(department: str, db=Depends(get_db)):
    return db.query(models.Announcement).order_by(
        desc(models.Announcement.id)
    ).filter(models.Announcement.department == department).all()
