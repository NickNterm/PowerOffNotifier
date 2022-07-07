from fastapi import FastAPI, Depends
from pydantic import BaseModel
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
    return db.query(models.Announcement).all()


@app.get("/latest")
def get_latest_announcement_by_department(department: str, id: int, db=Depends(get_db)):
    return db.query(models.Announcement).filter(models.Announcement.department == department, models.Announcement.id > id).all()


@app.get("/{department}")
def get_announcement_by_department(department: str, db=Depends(get_db)):
    return db.query(models.Announcement).filter(models.Announcement.department == department).all()
