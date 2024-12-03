import json
from flask import Flask, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from authlib.integrations.flask_client import OAuth
import os
from db import db, User, Connection, Chat, Message  # Import models from db.py

app = Flask(__name__)
app.secret_key = 'WPL_AP1.iSxHIYD46qrXhsHS.UtMqJQ=='  # Secret key for session management
db_filename = "lockedin.db"
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db.init_app(app)

# OAuth setup
oauth = OAuth(app)

linkedin = oauth.register(
    name="linkedin",
    client_id="YOUR_CLIENT_ID",
    client_secret="YOUR_CLIENT_SECRET",
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
    token = linkedin.authorize_access_token()
    user = linkedin.get("https://api.linkedin.com/v2/me", token=token)
    user_data = user.json()

    # Create or update the user in the database
    linkedin_username = user_data["id"]
    name = user_data["localizedFirstName"] + " " + user_data["localizedLastName"]

    user = User.query.filter_by(linkedin_username=linkedin_username).first()
    if not user:
        user = User(linkedin_username=linkedin_username, name=name)
        db.session.add(user)
        db.session.commit()

    return success_response({"message": "User authenticated", "user": user.serialize()})

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
    location = body.get("location", "")

    if any(x is None for x in [linkedin_username, name]):
        return failure_response("Improper Arguments", 400)

    new_user = User(
        linkedin_username=linkedin_username,
        name=name,
        goals=goals,
        interests=interests,
        university=university,
        major=major,
        company=company,
        job_title=job_title,
        location=location
    )
    db.session.add(new_user)
    db.session.commit()

    return success_response(new_user.serialize(), 201)

@app.route("/api/users/<int:id>/", methods=["GET"])
def get_user(id):
    user = User.query.filter_by(id=id).first()
    return success_response(user.serialize()) if user else failure_response("User not found")

# Routes for connections
@app.route("/api/connections/", methods=["POST"])
def create_connection():
    body = json.loads(request.data)
    user1_id = body.get("user1_id")
    user2_id = body.get("user2_id")

    if any(x is None for x in [user1_id, user2_id]):
        return failure_response("Improper Arguments", 400)

    new_connection = Connection(user1_id=user1_id, user2_id=user2_id)
    db.session.add(new_connection)
    db.session.commit()

    return success_response(new_connection.serialize(), 201)

@app.route("/api/connections/<int:user_id>/", methods=["GET"])
def get_user_connections(user_id):
    connections = Connection.query.filter((Connection.user1_id == user_id) | (Connection.user2_id == user_id)).all()
    return success_response({"connections": [conn.serialize() for conn in connections]})

@app.route("/api/connections/<int:user_id>/recommended", methods=["GET"])
def get_recommended_connections(user_id):
    # Logic for recommending up to 10 connections based on some criteria
    # Placeholder for actual recommendation logic
    recommended = User.query.limit(10).all()
    return success_response({"recommended": [user.serialize() for user in recommended]})

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