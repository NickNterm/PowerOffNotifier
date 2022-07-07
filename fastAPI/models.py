from sqlalchemy import Boolean, Column, Integer, String
from database import Base


class Announcement(Base):
    __tablename__ = "deddhe"

    id = Column(Integer, primary_key=True, index=True)
    start_date = Column(String)
    end_date = Column(String)
    department = Column(String)
    municipality = Column(String)
    description = Column(String)
    note_number = Column(String)
    type = Column(String)
