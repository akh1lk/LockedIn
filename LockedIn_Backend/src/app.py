import json
from flask import Flask, request, redirect, url_for
from authlib.integrations.flask_client import OAuth
import os
from db import db, User, Connection, Chat, Message, Asset  # Import models from db.py
from flask_socketio import SocketIO, join_room, leave_room, emit

app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY")  # Secret key for session management
db_filename = "lockedin.db"
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db.init_app(app)

# OAuth setup
oauth = OAuth(app)

linkedin = oauth.register(
    name="linkedin",
    client_id=os.environ.get("LINKEDIN_CLIENT_ID"),
    client_secret=os.environ.get("LINKEDIN_CLIENT_SECRET"),
    authorize_url="https://www.linkedin.com/oauth/v2/authorization",
    authorize_params=None,
    access_token_url="https://www.linkedin.com/oauth/v2/accessToken",
    refresh_token_url=None,
    api_base_url='https://api.linkedin.com/v2/',
    client_kwargs={"scope": "openid profile email"},
)

# Initialize Flask-SocketIO
socketio = SocketIO(app, cors_allowed_origins="*")

# Helper functions for response formatting
def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# Routes for LinkedIn authentication - We can have a button that does this"
@app.route("/login")
def login():
    return linkedin.authorize_redirect(redirect_uri="http://34.85.161.67/auth")

@app.route("/auth")
def auth():
    try:
        token = linkedin.authorize_access_token()               
        #base of token
        user = linkedin.get("https://api.linkedin.com/v2/userinfo", token=token)
        user_data = user.json()

        # Extract and validate fields - from Linkedin API's user_data
        name = user_data.get("name").strip()
        if not name:
            return failure_response("Name not found", 400)
        
        linkedin_sub = user_data.get("linkedin_sub")
        if not linkedin_sub:
            return failure_response("LinkedIn Sub not found", 404)
        
        # Check if user already exists in the database
        existing_user = User.query.filter_by(linkedin_sub=linkedin_sub).first()
        if existing_user:
            return success_response({"message": "Logging In", "user": existing_user.serialize()})

        # Create a new user with default or empty values for missing optional fields
        new_user = User(
            linkedin_sub=linkedin_sub,
            name=name,
            goals="",
            interests="",
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

@app.route("/upload/<int:user_id>/", methods=["POST"])
def upload(user_id):
    """
    Endpoint for uploading a new user's profile pic to AWS given its base64 form,
    then storing/returning the URL of that image.
    Should be called in conjunction with create_user INITIALLY.
    Can be called to update user's profile picture.
    """
    body = json.loads(request.data)
    image_data = body.get("image_data")

    if not image_data or not user_id:
        return failure_response("No base64 img string provided &/or user id", 404)
    
    user = User.query.get(id=user_id)
    if not user:
        return failure_response("User not found", 404)
    
    if user.profile_pic:
        user.profile_pic.replace(image_data)
    else:
        asset = Asset(user_id=user_id,image_data=image_data)
        db.session.add(asset)
        user.profile_pic = asset
    db.session.commit()

    return success_response(user.profile_pic.serialize(), 201)

@app.route("/api/users/<int:id>/", methods=["GET"])
def get_user(id):
    user = User.query.filter_by(id=id).first()
    return success_response(user.serialize()) if user else failure_response("User not found")

@app.route("/api/users/<int:id>/", methods=["POST"])
def update_user(id):
    """
    Updates user's profile info. Linkedin_username is immutable
    """
    body = json.loads(request.data)
    linkedin_username = body.get("linkedin_username", "")
    name = body.get("name", "")
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
        return failure_response("Cannot modify linkedin_username", 404)
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
    """
    Creates Connection if not existing
    200 - Exists
    201 - New Connection Created
    """
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
    user = User.query.get(id=user_id)
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

@app.route("/api/connections/<int:connection_id>", methods=["DELETE"])
def delete_user_connections(connection_id):
    """
    Delete user's connection, and subsuquent messages & chat.
    """
    connection = Connection.query.get(id=connection_id)
    user1 = connection.user1_id
    user2 = connection.user2_id

    if not connection:
        return failure_response("Connection doesn't exist", 404)
    
    chat = Chat.query.filter(
        ((Chat.user1_id == connection.user1_id) & (Chat.user2_id == connection.user2_id)) |
        ((Chat.user1_id == connection.user2_id) & (Chat.user2_id == connection.user1_id))
    ).first()

    if chat:
        db.session.delete(chat)

    db.session.delete(connection)
    db.session.commit()

    return success_response({"message": f"Connection {connection_id} with {user1} and \
                             {user2} and related chat/messages deleted successfully"})


@app.route('/recommendations/<int:user_id>', methods=['GET'])
def get_recommendations(user_id):
    """
    Get up to 10 user recommendations.
    """
    user = User.query.get(id=user_id)
    if not user:
        return {"error": "User not found"}, 404

    recommendations = user.recommend_users(max_results=10)
    return success_response({"recommendations": recommendations})

# Routes for chats and messages

@app.route("/api/chats/", methods=["POST"])
def create_chat():
    """
    Creates a new chat
    Pre-Req: a new connection was created i.e. /api/connections/ returned 201
    """
    body = json.loads(request.data)
    user1_id = body.get("user1_id")
    user2_id = body.get("user2_id")

    if any(x is None for x in [user1_id, user2_id]):
        return failure_response("Improper Arguments", 400)
    
    # Validate that a connection exists
    connection = Connection.query.filter(
        ((Connection.user1_id == user1_id) & (Connection.user2_id == user2_id)) |
        ((Connection.user1_id == user2_id) & (Connection.user2_id == user1_id))
    ).first()

    if not connection:
        return failure_response("Connection required to create a chat.", 403)
    
    # Check if the chat already exists
    chat = Chat.query.filter(
        ((Chat.user1_id == user1_id) & (Chat.user2_id == user2_id)) |
        ((Chat.user1_id == user2_id) & (Chat.user2_id == user1_id))
    ).first()

    if chat:
        return success_response(chat.serialize(), 200)

    new_chat = Chat(user1_id=user1_id, user2_id=user2_id)
    db.session.add(new_chat)
    db.session.commit()

    return success_response(new_chat.serialize(), 201)

@app.route("/api/chats/<int:user_id>/", methods=["GET"])
def get_user_chats(user_id):
    """
    Get All of User's chat's, along with most recent message and timestamp
    ^ for frontend display on chat page
    """
    user = User.query.get(id=user_id)
    if not user:
        return failure_response("User not found", 404)
    
    chats = Chat.query.filter((Chat.user1_id == user_id) | (Chat.user2_id == user_id)).order_by(Chat.timestamp.desc()).all()
    #return chat_ids with users in each chat
    return success_response({"chats": c.short_recentmsg_serialize() for c in chats})


@app.route("/api/chats/messages/<int:user1_id>/<int:user2_id>/", methods=["GET"])
def get_chat_history(user1_id, user2_id):
    """
    Returns messages between 'user1' and 'user2' - Newest Messages are first
    """
    MAX_MESSAGES_REFRESH = 15
    chat = Chat.query.filter(
        ((Chat.user1_id == user1_id) & (Chat.user2_id == user2_id)) |
        ((Chat.user1_id == user2_id) & (Chat.user2_id == user1_id))
    ).first()
    if not chat:
        return failure_response("Chat not found", 404)
    
    #get 15 messages max, descending order = newest is first
    messages = Message.query.filter_by(chat_id=chat.id).order_by(
        Message.timestamp.desc()).limit(MAX_MESSAGES_REFRESH).all()

    return success_response({"chat_id": chat.id, "messages": [msg.serialize() for msg in messages]})

#WebSocket - Real-Time Messaging Integration

#entering a chat room
@socketio.on("join")
def handle_join(data):
    chat_id = data.get("chat_id")
    user_id = data.get("user_id")

    if not chat_id or not user_id:
        emit("error", {"message": "chat_id and user_id are required."})
        return
    
    if Chat.query.get(id=chat_id) is None:
        emit("error", {"message": "chat_id invalid."})
        return
    
    if User.query.get(id=user_id) is None:
        emit("error", {"message": "user_id invalid."})
        return 

    join_room(chat_id)
    emit("message", {"message": f"User {user_id} joined chat {chat_id}"}, room=chat_id)

# Leaving a chat room
@socketio.on("leave")
def handle_leave(data):
    chat_id = data.get("chat_id")
    user_id = data.get("user_id")

    if not chat_id or not user_id:
        emit("error", {"message": "chat_id and user_id are required."})
        return

    leave_room(chat_id)
    emit("message", {"message": f"User {user_id} left chat {chat_id}"}, room=chat_id)

@socketio.on("connect")
def handle_connect():
    print("Client connected")

@socketio.on("disconnect")
def handle_disconnect():
    print("Client disconnected")

@socketio.on("send_message")
def handle_send_message(data):
    chat_id = data.get("chat_id")
    sender_id = data.get("sender_id")
    content = data.get("content")

    if not chat_id or not sender_id or not content:
        emit("error", {"message": "chat_id, sender_id, and content are required."})
        return
    
    sender_user = User.query.get(id=sender_id)
    if not sender_user:
        emit("error", {"message": "User not found"})
        return
    
    chat = Chat.query.get(id=chat_id)
    if not chat:
        emit("error", {"message": "Chat not found"})
        return

    # Save message to the database
    new_message = Message(chat_id=chat_id, sender_id=sender_id, content=content)
    db.session.add(new_message)
    db.session.commit()

    # Broadcast message to the room
    emit("message", new_message.serialize(), room=chat_id)

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=8000, debug=True)