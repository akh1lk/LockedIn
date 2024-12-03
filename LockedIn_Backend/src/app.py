import json
from flask import Flask, request, redirect, url_for
from authlib.integrations.flask_client import OAuth
import os
from db import db, User, Connection, Chat, Message  # Import models from db.py

app = Flask(__name__)
app.secret_key = 'b1f849a9870a6137b4d34f5d703ce70e'  # Secret key for session management
db_filename = "lockedin.db"
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db.init_app(app)

# OAuth setup
oauth = OAuth(app)

linkedin = oauth.register(
    name="linkedin",
    client_id="77w8k8tmep8y6p",
    client_secret="WPL_AP1.iSxHIYD46qrXhsHS.UtMqJQ==",
    authorize_url="https://www.linkedin.com/oauth/v2/authorization",
    authorize_params=None,
    access_token_url="https://www.linkedin.com/oauth/v2/accessToken",
    refresh_token_url=None,
    client_kwargs={"scope": "r_liteprofile r_emailaddress"},
)

# Helper functions for response formatting
def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# Routes for LinkedIn authentication
@app.route("/login")
def login():
    return linkedin.authorize_redirect(redirect_uri="YOUR_REDIRECT_URI")

@app.route("/auth")
def auth():
    try:
        token = linkedin.authorize_access_token()
        user = linkedin.get("https://api.linkedin.com/v2/me", token=token)
        user_data = user.json()

        # Extract and validate fields
        linkedin_username = user_data.get("id")
        if not linkedin_username:
            return failure_response("LinkedIn username not found", 400)

        name = user_data.get("localizedFirstName", "") + " " + user_data.get("localizedLastName", "")
        if not name.strip():
            return failure_response("Name not found", 400)

        # Check if user already exists in the database
        existing_user = User.query.filter_by(linkedin_username=linkedin_username).first()
        if existing_user:
            return success_response({"message": "Logging In", "user": existing_user.serialize()})

        # Create a new user with default or empty values for missing optional fields
        new_user = User(
            linkedin_username=linkedin_username,
            name=name.strip(),
            goals="",  # Defaults
            interests="",  # Defaults
            university="",
            major="",
            company="",
            job_title="",
            experience="",
            location=""
        )
        db.session.add(new_user)
        db.session.commit()

        return success_response({"message": "User authenticated & creating", "user": new_user.serialize()})
    except Exception as e:
        return failure_response(f"Authentication failed: {str(e)}", 500)

# Routes for users
@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    linkedin_username = body.get("linkedin_username")
    name = body.get("name")
    goals = body.get("goals", "")
    interests = body.get("interests", "")
    university = body.get("university", "")
    major = body.get("major", "")
    company = body.get("company", "")
    job_title = body.get("job_title", "")
    experience = body.get("experience", "")
    location = body.get("location", "")

    if any(x is None for x in [linkedin_username, name]):
        return failure_response("Improper Arguments", 400)
    
    if len(experience.split()) > 52:
        return failure_response("Experience Too Long", 400)
    
    existing_user = User.query.filter_by(linkedin_username=linkedin_username).first()
    
    if not existing_user:
        return failure_response("User Does Not Exist (Auth Didn't Happen)", 404)
    #Update user with real info
    existing_user.name = name
    existing_user.goals = goals
    existing_user.interests = interests
    existing_user.university = university
    existing_user.major = major
    existing_user.company = company
    existing_user.experience = experience
    existing_user.job_title = job_title
    existing_user.location = location
    #save changes
    db.session.commit()

    return success_response(existing_user.serialize(), 200)

@app.route("/api/users/<int:id>/", methods=["GET"])
def get_user(id):
    user = User.query.filter_by(id=id).first()
    return success_response(user.serialize()) if user else failure_response("User not found")

@app.route("/api/users/<int:id>/", methods=["POST"])
def update_user(id):
    body = json.loads(request.data)
    linkedin_username = body.get("linkedin_username")
    name = body.get("name")
    goals = body.get("goals", "")
    interests = body.get("interests", "")
    university = body.get("university", "")
    major = body.get("major", "")
    company = body.get("company", "")
    job_title = body.get("job_title", "")
    experience = body.get("experience", "")
    location = body.get("location", "")

    user = User.query.filter_by(id=id).first()
    if not user:
        return failure_response("User not found", 404)
    
    # Update each field only if it is not an empty string
    if linkedin_username:
        user.linkedin_username = linkedin_username
    if name:
        user.name = name
    if goals:
        user.goals = goals
    if interests:
        user.interests = interests
    if university:
        user.university = university
    if major:
        user.major = major
    if company:
        user.company = company
    if job_title:
        user.job_title = job_title
    if experience:
        user.experience = experience
    if location:
        user.location = location

    db.session.commit()

    return success_response(user.serialize())



# Routes for connections
@app.route("/api/connections/", methods=["POST"])
def create_connection():
    body = json.loads(request.data)
    user1_id = body.get("user1_id")
    user2_id = body.get("user2_id")

    #Checking For Improper Inputs
    if any(x is None for x in [user1_id, user2_id]):
        return failure_response("Improper Arguments", 400)
    
    if user1_id == user2_id:
        return failure_response("A user cannot be connected with themselves.", 400)
    
    user1 = User.query.get(id=user1_id)
    user2 = User.query.get(id=user2_id)
    if not user1 or not user2:
        return failure_response("One or both users do not exist", 404)
    
    # Check if the connection already exists
    existing_connection = Connection.query.filter(
        ((Connection.user1_id == user1_id) & (Connection.user2_id == user2_id)) |
        ((Connection.user1_id == user2_id) & (Connection.user2_id == user1_id))
    ).first()

    #do
    if existing_connection:
        return success_response(existing_connection.serialize(), 200)

    new_connection = Connection(user1_id=user1_id, user2_id=user2_id)
    db.session.add(new_connection)
    db.session.commit()

    return success_response(new_connection.serialize(), 201)

@app.route("/api/connections/<int:user_id>/", methods=["GET"])
def get_user_connections(user_id):
    user = User.query.get(user_id)
    if not user:
        return failure_response("User not found", 404)
    connections = Connection.query.filter(
        (Connection.user1_id == user_id) | (Connection.user2_id == user_id)
        ).all()
    connected_users = [ {
        "connection_id" : conn.id,
        "connected_user": conn.user2.serialize() if conn.user1_id == user_id else conn.user1.serialize(),
        "timestamp": conn.timestamp
    } for conn in connections]
    return success_response({"connections": connected_users})

@app.route('/recommendations/<int:user_id>', methods=['GET'])
def get_recommendations(user_id):
    """
    Get user recommendations.
    """
    user = User.query.get(user_id)
    if not user:
        return {"error": "User not found"}, 404

    recommendations = user.recommend_users(max_results=10)
    return {"recommendations": recommendations}, 200

# Routes for chats and messages
@app.route("/api/chats/", methods=["POST"])
def create_chat():
    body = json.loads(request.data)
    user1_id = body.get("user1_id")
    user2_id = body.get("user2_id")

    if any(x is None for x in [user1_id, user2_id]):
        return failure_response("Improper Arguments", 400)

    new_chat = Chat(user1_id=user1_id, user2_id=user2_id)
    db.session.add(new_chat)
    db.session.commit()

    return success_response(new_chat.serialize(), 201)

@app.route("/api/chats/<int:chat_id>/messages", methods=["POST"])
def send_message(chat_id):
    body = json.loads(request.data)
    sender_id = body.get("sender_id")
    content = body.get("content")

    if any(x is None for x in [sender_id, content]):
        return failure_response("Improper Arguments", 400)

    new_message = Message(chat_id=chat_id, sender_id=sender_id, content=content)
    db.session.add(new_message)
    db.session.commit()

    return success_response(new_message.serialize(), 201)

@app.route("/api/chats/<int:chat_id>/messages", methods=["GET"])
def get_chat_messages(chat_id):
    chat = Chat.query.filter_by(id=chat_id).first()
    if not chat:
        return failure_response("Chat not found", 404)

    return success_response({"messages": [msg.serialize() for msg in chat.messages]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)