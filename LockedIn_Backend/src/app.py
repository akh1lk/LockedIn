import json
from flask import Flask, request, redirect, url_for
from authlib.integrations.flask_client import OAuth
import os
from dotenv import load_dotenv
from db import db, User, Connection, Message, Swipe, Asset  # Import models from db.py

load_dotenv()

app = Flask(__name__)
db_filename = "lockedin.db"
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db.init_app(app)

SERVER_IP=os.environ.get("SERVER_IP")

# Helper functions for response formatting
def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

@app.route("/", methods=["GET"])
def test():
    return success_response(os.environ.get("HELLO"))

# Check if firebase user_id is in our database
@app.route("/api/users/<string:firebase_id>", methods=["GET"])
def check_user(firebase_id):
    user = User.query.filter_by(firebase_id=firebase_id).first()
    if user:
        return success_response({"message": "User exists", "user": user.serialize()})
    return failure_response("User not found", 404)

#Beginning of User Creation Routes (all must be called to finish creating user)
    
@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    Creates a new user
    """
    body = json.loads(request.data)
    firebase_id = body.get("firebase_id")
    name = body.get("name")  # Mandatory for creating a user
    goals = body.get("goals")  # CSV
    interests = body.get("interests")  # CSV
    university = body.get("university")
    major = body.get("major")
    company = body.get("company")
    job_title = body.get("job_title")
    experience = body.get("experience")
    location = body.get("location")
    profile_pic = body.get("profile_pic")

    if not name:
        return failure_response("Name is required to create a user", 400)

    if experience and len(experience.split()) > 52:  # Greater than 50 words with leniency
        return failure_response("Experience too long", 400)

    new_user = User(
        firebase_id = firebase_id,
        name=name,
        goals=goals,
        interests=interests,
        university=university,
        major=major,
        company=company,
        job_title=job_title,
        experience=experience,
        location=location,
    )

    # Save user to the database
    db.session.add(new_user)
    db.session.commit()
    # Add profile picture if provided
    if profile_pic:
        new_asset = Asset(user_id=new_user.id, image_data=profile_pic)
        db.session.add(new_asset)

    db.session.commit()

    return success_response(new_user.serialize(), 201)


@app.route("/api/users/<int:user_id>/", methods=["POST"])
def update_user(user_id):
    """
    Updates an existing user
    """
    body = json.loads(request.data)
    goals = body.get("goals")  # CSV
    interests = body.get("interests")  # CSV
    university = body.get("university")
    major = body.get("major")
    company = body.get("company")
    job_title = body.get("job_title")
    experience = body.get("experience")
    location = body.get("location")
    image_data = body.get("image_data")

    existing_user = User.query.filter_by(id=user_id).first()

    if not existing_user:
        return failure_response("User not found", 404)

    if experience and len(experience.split()) > 52:  # Greater than 50 words with leniency
        return failure_response("Experience too long", 400)

    # Update user fields if provided
    if goals:
        existing_user.goals = goals
    if interests:
        existing_user.interests = interests
    if university:
        existing_user.university = university
    if major:
        existing_user.major = major
    if company:
        existing_user.company = company
    if job_title:
        existing_user.job_title = job_title
    if experience:
        existing_user.experience = experience
    if location:
        existing_user.location = location

    # Handle profile picture update
    if image_data:
        if existing_user.profile_pic:
            existing_user.profile_pic.replace(image_data)
        else:
            new_asset = Asset(user_id=user_id, image_data=image_data)
            db.session.add(new_asset)

    db.session.commit()

    return success_response(existing_user.serialize(), 200)

#End of User Creation Routes (all must be called to finish creating user)

# Standard User Routes (GET, DELETE)

@app.route("/api/users/", methods=["GET"])
def get_all_users():
    return success_response({"users": [user.serialize() for user in User.query.all()]})

@app.route("/api/users/<int:user_id>/", methods=["GET"])
def get_user(user_id): #firebase_id
    #user = User.query.filter_by(id=firebased_id).first()
    user = User.query.filter_by(id=user_id).first()
    return success_response({"user": user.serialize()}) if user else failure_response("User not found")

@app.route("/api/users/<int:user_id>/recommendations/", methods=["GET"])
def recommend_users(user_id): #firebase_id
    """
    Recommends users based on the current user's preferences and data.
    """
    # Retrieve the current user
    current_user = User.query.fi
    current_user = User.query.filter_by(id=user_id).first()
    if not current_user:
        return failure_response("User not found", 404)

    # Optional: Number of recommendations to return (default: 10)
    max_results = request.args.get("max_results", default=10, type=int)

    # Get recommendations using the model's method
    recommendations = current_user.recommend_users(max_results=max_results)

    return success_response({"recommendations": recommendations})

@app.route("/api/users/<int:user_id>/", methods=["DELETE"])
def delete_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    user_data = user.serialize()

    if user is None:
        return failure_response("Course not found", 404)
    
    db.session.delete(user)
    db.session.commit()
    return success_response(user_data)

#Swipe Routes

@app.route("/api/swipes/", methods=["POST"])
def create_swipe():
    """
    Creates Swipe. If Mutual Swipe Exists, Creates Connection
    """
    body = json.loads(request.data)
    swiper_id = body.get("swiper_id")
    swiped_id = body.get("swiped_id")

    if not swiper_id or not swiped_id:
        return failure_response("Swiper ID and Swiped ID are required", 400)
    
    if swiper_id == swiped_id:
        return failure_response("Swiper and Swiped users cannot be the same", 400)
    
    # Check if users exist
    swiper = User.query.filter_by(id=swiper_id).first()
    swiped = User.query.filter_by(id=swiped_id).first()
    if not swiper or not swiped:
        return failure_response("One or both users not found", 404)
    
    # Check for mutual swipe and create a connection if necessary
    mutual_swipe = Swipe.query.filter_by(swiper_id=swiped_id, swiped_id=swiper_id).first()
    new_swipe = Swipe(swiper_id=swiper_id, swiped_id=swiped_id)
    db.session.add(new_swipe)

    if mutual_swipe:  # Mutual right swipe found
        new_connection = Connection(user1_id=swiper_id, user2_id=swiped_id)
        db.session.add(new_connection)

    db.session.commit()
    return success_response({"swipe": new_swipe.serialize()}, 201)
           
# Standard Swipe Routes (GET, DELETE)
@app.route("/api/swipes/", methods=["GET"])
def get_all_swipes():
    return success_response({"swipes": [swipe.serialize() for swipe in Swipe.query.all()]})

@app.route("/api/swipes/<int:swipe_id>/", methods=["GET"])
def get_swipe(swipe_id):
    """
    Returns swipe by swipe id
    """
    swipe = Swipe.query.filter_by(id=swipe_id).first()
    return success_response({"swipe": swipe.serialize()}) if swipe else failure_response("Swipe not found", 404)

@app.route("/api/users/<int:user_id>/swipes/", methods=["GET"])
def get_user_swipes(user_id):
    """
    Retrieves all swipes initiated by a specific user.
    """
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)

    return success_response({"swipes_initiated": [swipe.serialize() for swipe in user.swipes_initiated], "swipes_received": [swipe.serialize() for swipe in user.swipes_received]})


# Connection Routes

@app.route("/api/connections/", methods=["GET"])
def get_all_connections():
    """
    Retrieves all connections in the system.
    """
    connections = Connection.query.all()
    return success_response({"connections": [connection.serialize() for connection in connections]})


# Get a user's connections is in Messaging Section

@app.route("/api/connections/<int:connection_id>/", methods=["DELETE"])
def delete_connection(connection_id):
    """
    Deletes a specific connection.
    """
    connection = Connection.query.filter_by(id=connection_id).first()
    if not connection:
        return failure_response("Connection not found", 404)

    db.session.delete(connection)
    db.session.commit()
    return success_response({"message": "Connection deleted successfully"})


@app.route("/api/connections/check/", methods=["GET"])
def check_connection():
    """
    Checks if two users are connected.
    Query Params: user1_id, user2_id
    """
    user1_id = request.args.get("user1_id")
    user2_id = request.args.get("user2_id")

    if not user1_id or not user2_id:
        return failure_response("Both user1_id and user2_id are required", 400)

    connection = Connection.query.filter(
        ((Connection.user1_id == user1_id) & (Connection.user2_id == user2_id)) |
        ((Connection.user1_id == user2_id) & (Connection.user2_id == user1_id))
    ).first()

    return success_response({"connected": bool(connection)})

# Messaging Routes - To Be Implemented With FireBase

@app.route("/api/connections/<int:connection_id>/messages/", methods=["POST"])
def create_message(connection_id):
    """
    Creates a new message in a specific connection.
    """
    body = json.loads(request.data)
    sender_id = body.get("sender_id")
    content = body.get("content")

    if not sender_id or not content:
        return failure_response("Sender ID and content are required", 400)

    # Validate connection
    connection = Connection.query.filter_by(id=connection_id).first()
    if not connection:
        return failure_response("Connection not found", 404)

    # Validate sender is part of the connection
    if sender_id not in [connection.user1_id, connection.user2_id]:
        return failure_response("Sender is not part of the connection", 403)

    # Create and save the message
    new_message = Message(
        connection_id=connection_id,
        sender_id=sender_id,
        content=content
    )
    db.session.add(new_message)
    db.session.commit()

    return success_response({"message": new_message.serialize()}, 201)

@app.route("/api/connections/<int:connection_id>/messages/", methods=["GET"])
def get_connection_message_history(connection_id):
    """
    Retrieves all messages for a specific connection. No cache updating yet.
    """
    connection = Connection.query.filter_by(id=connection_id).first()
    if not connection:
        return failure_response("Connection not found", 404)

    messages = Message.query.filter_by(connection_id=connection_id).order_by(Message.timestamp).all()
    return success_response({"messages": [message.serialize() for message in messages]})

@app.route("/api/users/<int:user_id>/connections/", methods=["GET"])
def get_user_connections(user_id):
    """
    For Chat Page Display (Adds Extra Stuff): Retrieves all connections for a specific user along with the most recent message in each connection.
    """
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)

    # Query connections where the user is either user1 or user2
    connections = Connection.query.filter(
        (Connection.user1_id == user_id) | (Connection.user2_id == user_id)
    ).all()

    result = []

    for connection in connections:
        # Get the most recent message in the connection
        latest_message = Message.query.filter_by(connection_id=connection.id).order_by(Message.timestamp.desc()).first()

        # Determine the other user in the connection
        other_user = (
            connection.user2 if connection.user1_id == user_id else connection.user1
        )

        #Easier For Frontend to Load
        if not latest_message:
            #Makeshift temp
            other_user_name = other_user.serialize().get("name", "User")
            latest_message = {"content": f"Start the Chat with {other_user_name}"}

            result.append({
            "connection": connection.serialize(),
            "other_user": other_user.serialize(),
            "latest_message": latest_message
            })


        result.append({
            "connection": connection.serialize(),
            "other_user": other_user.serialize(),
            "latest_message": latest_message.serialize() if latest_message else None
        })

    return success_response({"connections": result})

@app.route("/api/messages/<int:message_id>/", methods=["GET"])
def get_message(message_id):
    """
    Retrieves a specific message by ID.
    """
    message = Message.query.filter_by(id=message_id).first()

    return success_response({"message": message.serialize()}) if message else failure_response("Message not found", 404)


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=8000, debug=True)