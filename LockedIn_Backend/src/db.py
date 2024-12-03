# Team #3 MidPoint for AppDev Hackathon FA24

from flask_sqlalchemy import SQLAlchemy
from cryptography.fernet import Fernet
import cracked_weights

# SQLAlchemy and message encryption implementation
db = SQLAlchemy()

# Association table for connections (many-to-many)
connection_table = db.Table(
    "connections",
    db.Model.metadata,
    db.Column("id", db.Integer, primary_key=True, autoincrement=True),
    db.Column("user1_id", db.Integer, db.ForeignKey("users.id"), nullable=False),
    db.Column("user2_id", db.Integer, db.ForeignKey("users.id"), nullable=False),
    db.Column("timestamp", db.Date)
)


class User(db.Model):
    """
    User Model
    """

    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    linkedin_username = db.Column(db.String, unique=True, nullable=False)
    name = db.Column(db.String, nullable=False)
    goals = db.Column(db.String, nullable=False)  # Comma-separated values
    interests = db.Column(db.String, nullable=False)  # Comma-separated values
    university = db.Column(db.String, nullable=True)  # College/major input
    major = db.Column(db.String, nullable=True)
    company = db.Column(db.String, nullable=True)  # Job title/company input
    job_title = db.Column(db.String, nullable=True)
    project = db.Column(db.String(150), nullable=True)
    location = db.Column(db.String, nullable=False)
    cracked_rating = db.Column(db.Integer, default=0)  # Computed in app.py
    chat = db.relationship("Chat", cascade="delete")

    connections = db.relationship(
        "Connection", 
        primaryjoin = "or_(Connection.user1_id == User.id, Connection.user2_id == User.id)",
        backref="users"
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

    #Cracked Rating Implementation

    def calculate_cracked_rating(self):
        """
        Calculate the cracked rating based on weighted factors.
        Weights adjust based on input case:
        1. Both college/major and job_title/company
        2. College/major only
        3. Job_title/company only
        """
        if self.university and self.major and self.company and self.job_title:
            #college & major = 60%
            if college_score > 85:  # Top college threshold
                college_weight = 0.7 * .6
                major_weight = 0.3 * .6
            elif college_score > 70:  # Mid-tier college
                college_weight = 0.5 * .6
                major_weight = 0.5 * .6
            else:  # Lower-tier college
                college_weight = 0.3 * .6
                major_weight = 0.7 * .6
            job_title_weight = 0.3
            company_weight = 0.1
        elif self.university and self.major:
            if college_score > 85:  # Top college threshold
                college_weight = 0.7
                major_weight = 0.3
            elif college_score > 70:  # Mid-tier college
                college_weight = 0.5
                major_weight = 0.5
            else:  # Lower-tier college
                college_weight = 0.3
                major_weight = 0.7
            job_title_weight = 0.0
            company_weight = 0.0
        elif self.company and self.job_title:
            college_weight = 0.0
            major_weight = 0.0
            job_title_weight = 0.6
            company_weight = 0.4
        else:
            return 0  # No valid input for calculation        

        college_score = self.get_college_score(self.university)
        major_score = self.get_major_score(self.major)
        job_title_score = self.get_job_title_score(self.job_title)
        company_score = self.get_company_score(self.company)

        cracked_rating = (
            college_score * college_weight
            + major_score * major_weight
            + job_title_score * job_title_weight
            + company_score * company_weight
        )
        #lowest cracked rating is 50 - most humans are average
        return max(round(cracked_rating, 2), 50)

    @staticmethod
    def get_college_score(college):
        return cracked_weights.college_weightings.get(college, 50)  # Default lower score

    @staticmethod
    def get_major_score(major):
        return cracked_weights.major_weightings.get(major, 50)  # Default lower score

    @staticmethod
    def get_job_title_score(job_title):
        """
        Calculate the job title score based on high-paying roles and intern modifier.
        """

        # Define a base reduction for interns
        intern_reduction = 10

        # Normalize case to handle inputs like "Intern" or "intern"
        normalized_title = job_title.lower()

        # Check if the role includes "intern"
        is_intern = "intern" in normalized_title

        # Find base score for the role, default to a lower score for unlisted roles
        base_score = cracked_weights.high_paying_roles_weightings.get(
            job_title.replace("Intern", "").strip(), 50
        )

        # Apply the intern reduction if applicable
        if is_intern:
            return max(base_score - intern_reduction, 0)  # Ensure score doesn't go below 0

        return base_score

    @staticmethod
    def get_company_score(company):
        return cracked_weights.companies_weightings.get(company, 50)  # Default lower score

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
    
    def recommend_users(self, max_results=10):
        """
        Recommend users based on cracked_rating, similar interests/goals, and location.
        """
        # Query all users except the current one
        all_users = User.query.filter(User.id != self.id).all()

        recommendations = []
        #Don't add connected ids again
        connected_ids = {
            connection.user1_id if connection.user2_id == self.id else connection.user2_id
            for connection in self.connections
        }

        for user in all_users:
            if user.id in connected_ids:
                continue
            # Compute similarity metrics
            cracked_rating_diff = abs(self.cracked_rating - user.cracked_rating)
            common_interests = len(set(self.interests.split(",")) & set(user.interests.split(",")))
            common_goals = len(set(self.goals.split(",")) & set(user.goals.split(",")))
            location_match = 1 if self.location == user.location else 0

            # Weight factors (customize as needed)
            score = (
                (5 - cracked_rating_diff) * 0.4 +  # Cracked rating weight
                common_interests * 0.3 +          # Common interests weight
                common_goals * 0.2 +              # Common goals weight
                location_match * 0.1              # Location weight
            )

            recommendations.append((user, score))

        # Sort by score in descending order and get top results
        recommendations = sorted(recommendations, key=lambda x: x[1], reverse=True)
        top_recommendations = [rec[0] for rec in recommendations[:max_results]]

        # Serialize recommended users
        return [user.serialize() for user in top_recommendations]

class Connection(db.Model):
    """
    Connection Model for managing user connections.
    """

    __tablename__ = "connections"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user1_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    user2_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    timestamp = db.Column(db.DateTime, default=db.func.now())

    user1 = db.relationship("User", foreign_keys=[user1_id])
    user2 = db.relationship("User", foreign_keys=[user2_id])

    def __init__(self, **kwargs):
        self.user1_id = kwargs.get("user1_id")
        self.user2_id = kwargs.get("user2_id")

    def serialize(self):
        """
        Serialize Connection
        """
        return {
            "id": self.id,
            "user1_id": self.user1_id,
            "user2_id": self.user2_id,
            "timestamp": self.timestamp,
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