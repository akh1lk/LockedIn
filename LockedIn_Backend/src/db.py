from flask_sqlalchemy import SQLAlchemy
import base64
import boto3 #AWS
import datetime
import io
from io import BytesIO #I/O streams
from mimetypes import guess_extension, guess_type #guess file type from base64 string
import os
from PIL import Image # how we represent images
import re # regular expresssions
import string # perform string manipulation in Python
import cracked_weights

# SQLAlchemy and message encryption implementation
db = SQLAlchemy()

#Stuff for Image Uploading on AWS
#List of Acceptable Extentions .png gif, jpg, jpeg
EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
#base directory
BASE_DIR = os.getcwd()

S3_BUCKET_NAME = os.environ.get("AWS_S3_BUCKET_NAME") #"locked-in" 
ACCESS_KEY = os.environ.get("AWS_ACCESS_KEY") #"AKIAWNHTHOO25VJ6URCX"
SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY") #"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"
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-2.amazonaws.com"

class User(db.Model):
    """
    User Model
    1-to-1 w/ Asset
    Many-to-Many w/ Messages
    Many-to-Many w/ Chat
    """

    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    linkedin_sub = db.Column(db.String, unique=True, nullable=False)
    linkedin_url = db.Column(db.String, unique=False, nullable=True)
    name = db.Column(db.String, nullable=False)
    goals = db.Column(db.String, nullable=True)  # Comma-separated values
    interests = db.Column(db.String, nullable=True)  # Comma-separated values
    university = db.Column(db.String, nullable=True)  # College/major input
    major = db.Column(db.String, nullable=True)
    company = db.Column(db.String, nullable=True)  # Job title/company input
    job_title = db.Column(db.String, nullable=True)
    experience = db.Column(db.String(150), nullable=True)
    location = db.Column(db.String, nullable=True)
    cracked_rating = db.Column(db.Float, default=0)
    #Relationship (User to Asset - 1 to 1)
    profile_pic = db.relationship("Asset", uselist=False, back_populates="user")
    #Relationship to Swipes (1 to Many)
    swipes_initiated = db.relationship("Swipe", foreign_keys="[Swipe.swiper_id]", back_populates="swiper", cascade="all, delete",passive_deletes=True)
    swipes_received = db.relationship("Swipe", foreign_keys="[Swipe.swiped_id]", back_populates="swiper", cascade="all, delete",passive_deletes=True)
    #Relationships to Connections (Many to Many)
    connections_user1 = db.relationship("Connection", foreign_keys="[Connection.user1_id]",back_populates="user1", cascade="all, delete", passive_deletes=True)
    connections_user2 = db.relationship("Connection", foreign_keys="[Connection.user2_id]",back_populates="user2", cascade="all, delete", passive_deletes=True)
    #Relationship to Messages (One to Many)
    sent_messages = db.relationship("Message", back_populates="sender", cascade="all, delete-orphan")
    timestamp = db.Column(db.DateTime, nullable=False)


    def __init__(self, **kwargs):
        """
        Initialize User object
        """
        self.linkedin_sub = kwargs.get("linkedin_sub")
        self.name = kwargs.get("name")
        self.linkedin_url = f"https://www.linkedin.com/search/results/all/?keywords={self.name.strip().replace(' ', '%20')}&origin=GLOBAL_SEARCH_HEADER&sid=1v1"
        self.goals = kwargs.get("goals")
        self.interests = kwargs.get("interests")
        self.university = kwargs.get("university")
        self.major = kwargs.get("major")
        self.company = kwargs.get("company")
        self.job_title = kwargs.get("job_title")
        self.experience = kwargs.get("experience")
        self.location = kwargs.get("location")
        self.cracked_rating = self.calculate_cracked_rating()
        self.timestamp = datetime.datetime.now()

    #Cracked Rating Implementation

    def calculate_cracked_rating(self):
        """
        Calculate the cracked rating based on weighted factors.
        Weights adjust based on input case:
        1. Both college/major and job_title/company
        2. College/major only
        3. Job_title/company only
        """   

        college_score = self.get_college_score(self.university)
        major_score = self.get_major_score(self.major)
        job_title_score = self.get_job_title_score(self.job_title)
        company_score = self.get_company_score(self.company)

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
        Serialize User object - relationships not included
        """
        return {
            "id": self.id,
            "linkedin_sub": self.linkedin_sub,
            "linkedin_url": self.linkedin_url,
            "name": self.name,
            "goals": self.goals.split(",") if self.goals else [],
            "interests": self.interests.split(",") if self.interests else [],
            "university": self.university,
            "major": self.major,
            "company": self.company,
            "job_title": self.job_title,
            "experience": self.experience,
            "location": self.location,
            "cracked_rating": self.cracked_rating,
            "profile_pic": self.profile_pic.serialize() if self.profile_pic else None,
            "timestamp": self.timestamp.isoformat()
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
    
class Swipe(db.Model):
    """
    Swipe Model

    Many-to-Many -> Users (2 users / swipe)
    """

    __tablename__ = "swipes"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    swiper_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    swiped_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    is_right_swipe = db.Column(db.Boolean, default=True)
    timestamp = db.Column(db.DateTime,nullable=False)

    #Relationships - many to many
    swiper = db.relationship("User", foreign_keys=[swiper_id], back_populates="swipes_initiated")
    swiped = db.relationship("User", foreign_keys=[swiped_id], back_populates="swipes_received")

    def __init__(self, **kwargs):
        self.swiper_id = kwargs.get("swiper_id")
        self.swiped_id = kwargs.get("swiped_id")
        self.timestamp = datetime.datetime.now()

    def serialize(self):
        return {
            "id": self.id,
            "swiper": self.swiper.serialize() if self.swiper else None,
            "swiped": self.swiped.serialize() if self.swiped else None,
            "timestamp": self.timestamp.isoformat()
        }
    
class Connection(db.Model):
    """
    Connection Class
    Many-To-Many w/ User
    """

    __tablename__ = "connections"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user1_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    user2_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    timestamp = db.Column(db.DateTime,nullable=False)

    __table_args__ = (
        db.UniqueConstraint('user1_id', 'user2_id', name='unique_user_connection'),
    )

    user1 = db.relationship("User", foreign_keys=[user1_id], back_populates="connections_user1")
    user2 = db.relationship("User", foreign_keys=[user2_id], back_populates="connections_user2")

    messages = db.relationship("Message", back_populates="connection", cascade="all, delete-orphan", primaryjoin="Message.connection_id == Connection.id")
    def __init__(self, **kwargs):
        self.user1_id = kwargs.get("user1_id")
        self.user2_id = kwargs.get("user2_id")
        self.timestamp = datetime.datetime.now()

    def serialize(self):
        return {
            "id": self.id,
            "user1": self.user1.serialize() if self.user1 else None,
            "user2": self.user2.serialize() if self.user2 else None,
            "timestamp": self.timestamp.isoformat()
        }
    
class Message(db.Model):
    """
    Message Class
    Represents individual messages exchanged between users in a Connection.
    Message to Chat - Many to 1
    """

    __tablename__ = "messages"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    #Many to One
    connection_id = db.Column(db.Integer, db.ForeignKey('connections.id', ondelete="CASCADE"), nullable=False)
 
    #Many to One - dont delete messages of a user
    sender_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    content = db.Column(db.Text, nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)

    #Relationships
    connection = db.relationship("Connection", back_populates="messages")
    sender = db.relationship("User", back_populates="sent_messages")

    def __init__(self, **kwargs):
        """
        Initialize a Message object.
        """
        self.connection_id = kwargs.get("connection_id")
        self.sender_id = kwargs.get("sender_id")
        self.content = kwargs.get("content")
        self.timestamp = datetime.datetime.now()

    def serialize(self):
        """
        Serialize a Message object.
        """
        return {
            "id": self.id,
            "connection": self.connection.serialize() if self.connection else None,
            "sender": self.sender.serialize() if self.sender else None,
            "content": self.content,
            "timestamp": self.timestamp.isoformat()
        }

class Asset(db.Model):
    """
    Asset Model - based off of AppDev Backend's Image Demo
    1-to-1 w/ User
    """
    __tablename__ = "assets"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    base_url = db.Column(db.String, nullable=True)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    #Relationship (User to Asset - 1 to 1)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    
    user = db.relationship("User", back_populates="profile_pic")

    def __init__(self, **kwargs):
        """
        Initializes an asset object
        """
        self.user_id = kwargs.get("user_id")
        self.create(kwargs.get("image_data"))

    def create(self, image_data):
        """
        Given base64 image
        1. reject if improper file type
        2. decode image
        3. generate random string for file name
        4. calls upload function, which uploads to aws
        5. set image attributes in db
        """

        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Unsupported File Type {ext}")

            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            salt = f"user_{self.user_id}_{datetime.datetime.now().strftime('%Y%m%d%H%M%S')}"

            img_filename = f"{salt}.{ext}"

            self.upload(img, img_filename)

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()
        except Exception as e:
            print(f"Error when creating image {e}")


    def upload(self, img, img_filename):
        """
        Attempt to upload image to specified S3 Bucket
        """

        try:
            #img temporary location
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            s3_client = boto3.client("s3", 
                                     aws_access_key_id=ACCESS_KEY, 
                                     aws_secret_access_key=SECRET_ACCESS_KEY
                                     )
            s3_client.upload_file(img_temploc, S3_BUCKET_NAME, img_filename)
            #change permissions to be publcially accessible
            s3_resource = boto3.resource("s3", 
                                     aws_access_key_id=ACCESS_KEY, 
                                     aws_secret_access_key=SECRET_ACCESS_KEY
                                     )
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME, img_filename)
            object_acl.put(ACL="public-read")
            #remove from my server
            os.remove(img_temploc)

        except Exception as e:
            print(f"Error uploading image to S3 Bucket {e}")

    def delete(self):
        """
        Deletes the current asset from AWS and removes it from the database.
        """
        try:
            # Delete the file from AWS S3
            s3_client = boto3.client(
                "s3",
                aws_access_key_id=ACCESS_KEY,
                aws_secret_access_key=SECRET_ACCESS_KEY,
            )
            s3_client.delete_object(
                Bucket=S3_BUCKET_NAME,
                Key=f"{self.salt}.{self.extension}"
            )
            print("Deleted image from S3")
        except Exception as e:
            print(f"Error deleting image from AWS: {e}")
            raise e  # Raise the exception if AWS deletion fails
        # Remove from the database
        db.session.delete(self)

    def replace(self, image_data):
        """
        Replaces the current asset with a new image.
        1. Deletes the old asset from AWS.
        2. Updates the object with the new image's properties.
        """
        try:
            # Delete the old asset from AWS
            self.delete()
            self.create(image_data)
        except Exception as e:
            print(f"Error replacing image: {e}")

    def serialize(self):
        if not self.base_url:
            return 
        return {
            "url": f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at)
        }
    
