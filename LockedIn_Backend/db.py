from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# your classes here

#association_table

course_user_association_table = db.Table(
    "course_user_association_table",
    db.Model.metadata,
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("role", db.String, nullable=False) # student or instructor
)

class Course(db.Model):
    """
    Course Model
    One-To-Many -> Assignments
    Many-To-Many -> Instructors
    Many-To-Many -> Students
    """

    #columns
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    code = db.Column(db.String, nullable=False)
    name = db.Column(db.String,nullable=False)
    #foreign columns
    assignments = db.relationship("Assignment",cascade="delete")
    users = db.relationship("User", 
                                  secondary = course_user_association_table, 
                                  back_populates = "courses") 
    
    def __init__(self, **kwargs):
        """
        Initialize Course object
        """
        self.code = kwargs.get("code","")
        self.name = kwargs.get("name","")
         
    def serialize(self):
        return {
            "id":self.id,
            "name":self.name,
            "code":self.code,
            "assignments": [a.s_serialize() for a in self.assignments],
            "instructors": [user.s_serialize() for user in self.users if 
                             self.get_user_role(user.id) == "instructor"],
            "students": [user.s_serialize() for user in self.users if 
                             self.get_user_role(user.id) == "student"]
        }

    def s_serialize(self):
        return {
            "id":self.id,
            "name":self.name,
            "code":self.code
        }
    
    def get_user_role(self, user_id):
        # Helper method to fetch the role of a user in this course
        association = db.session.query(course_user_association_table).filter_by(
            course_id=self.id, user_id=user_id).first()
        return association.role if association else None
     
class Assignment(db.Model):
    """
    Assignment Model
    Many-To-One -> Course
    """
    __tablename__ = "assignments"
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    title = db.Column(db.String, nullable=False)
    due_date = db.Column(db.Integer, nullable=False)
    course_id = db.Column(db.String, db.ForeignKey("courses.id"),nullable=False)

    def __init__(self, **kwargs):
        self.title = kwargs.get("title","")
        self.due_date = int(kwargs.get("due_date",""))
        self.course_id = kwargs.get("course_id","")
        self.course = Course.query.filter_by(id=self.course_id).first()

    def serialize(self):
        return {
            "id":self.id,
            "title":self.title,
            "due_date":self.due_date,
            "course": self.course.s_serialize()
        }
    
    def s_serialize(self):
        return {
            "id":self.id,
            "title":self.title,
            "due_date":self.due_date,
        }

class User(db.Model):
    """
    Many-To-Many -> Courses
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    courses = db.relationship("Course",
                              secondary=course_user_association_table, 
                              back_populates="users")

    def __init__(self, **kwargs):
        self.name = kwargs.get("name","")
        self.netid = kwargs.get("netid","")

    def serialize(self):
        return {
            "id": self.id,
            "name":self.name,
            "netid":self.netid,
            "courses": [c.s_serialize() for c in self.courses]
        }
    
    def s_serialize(self):
        return {
            "id": self.id,
            "name":self.name,
            "netid":self.netid,
        }
    
