#Team #3 MidPoint for AppDev Hackathon FA24

from flask_sqlalchemy import SQLAlchemy
from cryptography.fernet import Fernet
#SQL Alchemy, Encrypt Messages implementation

db = SQLAlchemy()

# assocation table for connections (many to many)
connection_table = db.Table(
    "connections",
    db.Model.metadata,
    db.Column("id", db.Integer, primary_key=True, autoincrement=True),
    db.Column("user1_id", db.Integer, db.ForeignKey("users.id"), nullable=False),
    db.Column("user2_id", db.Integer, db.ForeignKey("users.id"), nullable=False),
)

class User(db.Model):
    """
    User Model

    Many-To-Many -> Connections
    One-To-Many -> Chat
    One-To
    """
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    linkedin_username = db.Column(db.String, unique=True, nullable=False)
    name = db.Column(db.String, nullable=False)
    goals = db.Column(db.String, nullable=False)  # Store as comma-separated values
    interests = db.Column(db.String, nullable=False)  # Store as comma-separated values
    university = db.Column(db.String, nullable=True) # Users can choose to show University/Major AND/OR Company/JobTitle
    major = db.Column(db.String, nullable=True)
    company = db.Column(db.String, nullable=True)
    job_title = db.Column(db.String, nullable=True)
    project = db.Column(db.String(150), nullable=True)
    location = db.Column(db.String, nullable=False)
    cracked_rating = db.Column(db.Integer, default=0) # functionality will be implemented in app.py
    chat = db.relationship("Chat", cascade="delete")

    connections = db.relationship(
        "User",
        secondary=connection_table,
        back_populates="connections"
    )

    def __init__(self, **kwargs):
        """
        Initialize User object
        """
        self.linkedin_username = kwargs.get("linkedin_username")
        self.name = kwargs.get("name")
        self.goals = kwargs.get("goals")
        self.interests = kwargs.get("interests")
        self.university = kwargs.get("university")
        self.major = kwargs.get("major")
        self.company = kwargs.get("company")
        self.job_title = kwargs.get("job_title")
        self.project = kwargs.get("project")
        self.location = kwargs.get("location")
        self.cracked_rating = kwargs.get("cracked_rating", 0)

    def serialize(self):
        """
        Serialize User object
        """
        return {
            "id": self.id,
            "linkedin_username": self.linkedin_username,
            "linkedin_url": f"https://www.linkedin.com/in/{self.linkedin_username}",
            "name": self.name,
            "goals": self.goals.split(","),
            "interests": self.interests.split(","),
            "university": self.university,
            "major": self.major,
            "company": self.company,
            "job_title": self.job_title,
            "project": self.project,
            "location": self.location,
            "cracked_rating": self.cracked_rating,
        }

class Message(db.Model):
    """
    Message Model
    """
    __tablename__ = "messages"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    chat_id = db.Column(db.Integer, db.ForeignKey("chats.id"), nullable=False)
    sender_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    content = db.Column(db.Text, nullable=False)
    timestamp = db.Column(db.DateTime, default=db.func.now())

    def __init__(self, **kwargs):
        """
        Initialize Message object
        """
        self.chat_id = kwargs.get("chat_id")
        self.sender_id = kwargs.get("sender_id")
        self.content = Fernet.encrypt(kwargs.get("content").encode()).decode()

    def serialize(self):
        """
        Serialize Message
        """
        return {
            "id": self.id,
            "chat_id": self.chat_id,
            "sender_id": self.sender_id,
            "content": Fernet.decrypt(self.content.encode()).decode(),
            "timestamp": self.timestamp,
        }

class Chat(db.Model):
    """
    Chat Model
    """
    __tablename__ = "chats"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user1_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    user2_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    messages = db.relationship("Message", cascade="all, delete")
    
    def __init__(self, **kwargs):
        """
        Initialize Chat object
        """
        self.user1_id = kwargs.get("user1_id")
        self.user2_id = kwargs.get("user2_id")

    def serialize(self):
        """
        Serialize Chat
        """
        return {
            "id": self.id,
            "user1_id": self.user1_id,
            "user2_id": self.user2_id,
            "messages": [m.serialize() for m in self.messages],
        }