from fastapi import FastAPI, Depends
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import desc
import models
from database import engine, SessionLocal

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


@app.get("/")
def get_all_announcement(db=Depends(get_db)):
    return db.query(models.Announcement).order_by(
        desc(models.Announcement.id)
    ).all()


@app.get("/latest")
def get_latest_announcement_by_department(department: str, id: int, db=Depends(get_db)):
    return db.query(models.Announcement).order_by(
        desc(models.Announcement.id)
    ).filter(models.Announcement.department == department, models.Announcement.id > id).all()


@app.get("/count")
def get_item_count(department: Optional[str] = None, db=Depends(get_db)):
    if department is not None:
        return db.query(models.Announcement).filter(models.Announcement.department == department).count()
    return db.query(models.Announcement).count()


@app.get("/{department}")
def get_announcement_by_department(department: str, db=Depends(get_db)):
    return db.query(models.Announcement).order_by(
        desc(models.Announcement.id)
    ).filter(models.Announcement.department == department).all()
