import json
import os

from db import db
from flask import Flask, request
from db import Course, Assignment, User, course_user_association_table

app = Flask(__name__)
db_filename = "cms.db"

app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

# generalized response formats
def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code


# your routes here
@app.route("/", methods=["GET"])
def hello():
    """
    Intro
    """
    return success_response(os.environ.get("NETID") + " was here!")

@app.route("/api/courses/", methods=["GET"])
def get_all_courses():
    """
    Returns all courses
    """
    return success_response({"courses": [c.serialize() for c in Course.query.all()]})

@app.route("/api/courses/", methods=["POST"])
def create_course():
    """
    Creates a course
    """
    body = json.loads(request.data)
    code = body.get("code")
    name = body.get("name")

    if any(x is None for x in [code, name]):
        return failure_response("Improper Arguments", 400)
    
    new_course = Course(code=code, name=name)
    db.session.add(new_course)
    db.session.commit()
    return success_response(new_course.serialize(), 201)

@app.route("/api/users/",methods=["POST"])
def create_user():
    """
    Creates a user
    """
    body = json.loads(request.data)
    name = body.get("name")
    netid = body.get("netid")

    if any(x is None for x in [netid, name]):
        return failure_response("Improper Arguments", 400)
    
    new_user = User(name=name, netid=netid)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)



@app.route("/api/courses/<int:course_id>/", methods=["GET"])
def get_course_id(course_id):
    """
    Returns a course with id
    """
    course = Course.query.filter_by(id=course_id).first()
    return success_response(course.serialize()) if course else failure_response("Course not found")

@app.route("/api/users/<int:user_id>/", methods=["GET"])
def get_user_id(user_id):
    """
    Returns a user with id
    """
    user = User.query.filter_by(id=user_id).first()
    return success_response(user.serialize()) if user else failure_response("User not found")

@app.route("/api/courses/<int:course_id>/add/", methods=["POST"])
def add_user_course(course_id):
    """
    Adds a user to course, and distinguishes them as either instructor or student
    """
    #get inputs
    body = json.loads(request.data)
    user_id = body.get("user_id")
    #changed because type is a keyword in python
    role = str(body.get("type"))
    print(role)
    if any(x is None for x in [user_id, role]):
        return failure_response("Improper Arguments")
    if role != "student" and role != "instructor":
        return failure_response("Improper Arguments")
    #query db to make sure course and user exists
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found", 404)
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found", 404)
    
    #check if user alr associated with course
    association = db.session.query(course_user_association_table).filter_by(
        course_id=course_id, user_id=user_id
    ).first()

    if association:
        return failure_response("User Already Added to Course", 400)
    
    #update association table / add user to course
    db.session.execute(course_user_association_table.insert().values(
        course_id = course_id,
        user_id = user_id,
        role = role
    ))

    db.session.commit()
    return success_response(course.serialize())

@app.route("/api/courses/<int:course_id>/assignment/", methods=["POST"])
def create_assignment(course_id):
    """
    Creates an assignment associated with course with id=course_id
    """
    body = json.loads(request.data)
    title = body.get("title")
    due_date = body.get("due_date")

    if any([x is None for x in [title, due_date]]):
        return failure_response("Need title & due_date", 400)
    
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found", 404)
    
    new_assignment = Assignment(title=title, due_date=due_date, course_id=course_id)
    db.session.add(new_assignment)
    db.session.commit()
    return success_response(new_assignment.serialize(), 201)

@app.route("/api/courses/<int:course_id>/", methods=["DELETE"])
def delete_course(course_id):
    """
    Deletes Course and associated data entrys in other tables associated with its id 
    """
    course = Course.query.filter_by(id=course_id).first()
    course_dict = course.serialize()

    if course is None:
        return failure_response("Course not found", 404)
    
    db.session.delete(course)
    db.session.commit()
    return success_response(course_dict)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
