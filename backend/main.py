from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, ForeignKey, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from datetime import datetime, timedelta
from typing import List, Optional
from passlib.context import CryptContext
from jose import JWTError, jwt
import os

# Configuration
SECRET_KEY = "votre_cle_secrete_tres_longue_et_securisee"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Database setup (SQLite pour la démo, facilement interchangeable avec PostgreSQL)
# Pour PostgreSQL, utilisez: postgresql://user:password@localhost/dbname
SQLALCHEMY_DATABASE_URL = "sqlite:///./digisante.db"

Base = declarative_base()
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Models
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String)
    email = Column(String, unique=True, index=True)
    password_hash = Column(String)

class HealthMetric(Base):
    __tablename__ = "health_metrics"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    respiration_rate = Column(Float)
    temperature = Column(Float)
    humidity = Column(Float)
    co2_level = Column(Float)
    risk_level = Column(String)
    measured_at = Column(DateTime, default=datetime.utcnow)

# Security
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# App
app = FastAPI(title="DIGISANTE API")

@app.on_event("startup")
def startup():
    Base.metadata.create_all(bind=engine)

@app.post("/register")
def register(full_name: str, email: str, password: str, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email déjà enregistré")
    new_user = User(full_name=full_name, email=email, password_hash=get_password_hash(password))
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"message": "Utilisateur créé avec succès"}

@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Email ou mot de passe incorrect")
    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/metrics", response_model=List[dict])
def get_metrics(db: Session = Depends(get_db)):
    # Pour la démo, on retourne les dernières mesures
    metrics = db.query(HealthMetric).order_by(HealthMetric.measured_at.desc()).limit(10).all()
    return [
        {
            "respiration": m.respiration_rate,
            "temperature": m.temperature,
            "humidity": m.humidity,
            "co2": m.co2_level,
            "risk": m.risk_level,
            "date": m.measured_at.isoformat()
        } for m in metrics
    ]

@app.post("/metrics")
def add_metric(respiration: float, temp: float, hum: float, co2: float, risk: str, db: Session = Depends(get_db)):
    new_metric = HealthMetric(
        respiration_rate=respiration,
        temperature=temp,
        humidity=hum,
        co2_level=co2,
        risk_level=risk
    )
    db.add(new_metric)
    db.commit()
    return {"message": "Mesure ajoutée"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
