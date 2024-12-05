import json
from flask import Flask, request, redirect, url_for
from authlib.integrations.flask_client import OAuth
import os
from db import db, User, Connection, Chat, Message, Asset  # Import models from db.py
from flask_socketio import SocketIO, join_room, leave_room, emit

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

# Initialize Flask-SocketIO
socketio = SocketIO(app, cors_allowed_origins="*")

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

@app.route("/upload/<int:user_id>", methods=["POST"])
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

    return success_response({"message": f"Connection {connection_id} with {user1} and {user2} and related chat/messages deleted successfully"})


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


"""
WorkFlow Explained

Workflow: New Chat

	1.	Create a Connection
	•	API Endpoint: POST /api/connections/
	•	Frontend Action: The frontend calls this when a user selects another user to connect with.
	•	Functionality:
	•	Checks if a connection exists between the two users (user1_id and user2_id).
	•	If no connection exists, creates a new connection.
	•	Returns the connection details.
	2.	Create a Chat
	•	API Endpoint: POST /api/chats/
	•	Frontend Action: The frontend calls this to create a chat for the newly established connection.
	•	Functionality:
	•	Validates that the two users are connected.
	•	Checks if a chat already exists for the connection.
	•	If no chat exists, creates a new one and returns the chat details.
	3.	Join the Chat Room
	•	Socket.IO Event: join
	•	Frontend Action: The frontend calls this to join the WebSocket room for the new chat.
	•	Functionality:
	•	Validates the chat_id and user_id.
	•	Adds the user to the room identified by chat_id.
	•	Notifies all participants in the room.
	4.	Send Messages
	•	Socket.IO Event: send_message
	•	Frontend Action: The frontend calls this to send real-time messages in the chat.
	•	Functionality:
	•	Validates the chat_id, sender_id, and content.
	•	Saves the message in the database.
	•	Broadcasts the message to all users in the room.

    Workflow: Existing Chat

	1.	Fetch Recent Chats
	•	API Endpoint: GET /api/chats/<int:user_id>/
	•	Frontend Action: The frontend calls this to display a list of recent chats on the user’s chat page.
	•	Functionality:
	•	Retrieves all chats for the user (user_id) in descending order of timestamp.
	•	Includes the most recent message and its timestamp for display.
	2.	Fetch Chat History
	•	API Endpoint: GET /api/chats/messages/<int:user1_id>/<int:user2_id>/
	•	Frontend Action: The frontend calls this when the user opens an existing chat.
	•	Functionality:
	•	Fetches up to 15 recent messages between the two users (user1_id and user2_id) in descending order of timestamp.
	3.	Join the Chat Room
	•	Socket.IO Event: join
	•	Frontend Action: The frontend calls this to join the WebSocket room for the existing chat.
	•	Functionality:
	•	Validates the chat_id and user_id.
	•	Adds the user to the room identified by chat_id.
	•	Notifies all participants in the room.
	4.	Send Messages
	•	Socket.IO Event: send_message
	•	Frontend Action: The frontend calls this to send real-time messages in the chat.
	•	Functionality:
	•	Validates the chat_id, sender_id, and content.
	•	Saves the message in the database.
	•	Broadcasts the message to all users in the room.

    Socket.IO Events

	1.	join
	•	Adds the user to a WebSocket room for the chat.
	2.	leave
	•	Removes the user from a WebSocket room for the chat.
	3.	send_message
	•	Handles real-time messaging:
	•	Saves the message in the database.
	•	Broadcasts the message to all participants in the chat room.
	4.	connect/disconnect
	•	Handles global WebSocket connection and disconnection events for logging or debugging.

    OAuth-Related Endpoints

	1.	GET /login
	•	Description: Initiates LinkedIn OAuth login.
	•	Flow:
	•	Redirects the user to LinkedIn’s authorization page (https://www.linkedin.com/oauth/v2/authorization).
	•	After the user grants permissions, LinkedIn redirects back to your application with an authorization code.
	•	Frontend Usage: Called when the user clicks “Login with LinkedIn.”
	2.	GET /auth
	•	Description: Handles LinkedIn OAuth callback after the user logs in.
	•	Flow:
	•	Exchanges the authorization code for an access token (https://www.linkedin.com/oauth/v2/accessToken).
	•	Fetches the user’s profile from LinkedIn using the token.
	•	Creates a new user in the database if the user doesn’t already exist.
	•	Returns a success response with user details.
	•	Frontend Usage: This endpoint is hit automatically by LinkedIn after login.

    User-Related Endpoints

	1.	POST /api/users/
	•	Description: Updates user details after OAuth login with additional information (e.g., goals, interests, university).
	•	Flow:
	•	Checks if the user exists (must already have been created during OAuth).
	•	Updates user details such as name, goals, interests, etc.
	•	Frontend Usage: Called after login to complete the user’s profile.
	2.	GET /api/users/<int:id>/
	•	Description: Fetches details of a specific user by id.
	•	Flow:
	•	Queries the database for the user.
	•	Returns the serialized user object if found.
	•	Frontend Usage: Used to retrieve a user’s profile details for display.
	3.	POST /api/users/<int:id>/
	•	Description: Updates the details of an existing user.
	•	Flow:
	•	Validates the provided data (e.g., name, goals).
	•	Updates only the fields that are provided in the request body.
	•	Frontend Usage: Allows the user to update their profile information.

    Connection-Related Endpoints

	1.	POST /api/connections/
	•	Description: Creates a connection between two users.
	•	Flow:
	•	Validates the user IDs (user1_id and user2_id).
	•	Checks if a connection already exists.
	•	Creates a new connection and stores it in the database.
	•	Frontend Usage: Called when a user initiates a connection with another user.
	2.	GET /api/connections/<int:user_id>/
	•	Description: Fetches all connections for a specific user.
	•	Flow:
	•	Queries the database for all connections where the user is either user1 or user2.
	•	Returns details of connected users.
	•	Frontend Usage: Used to display a list of all connections on the user’s dashboard.

    Chat-Related Endpoints

	1.	POST /api/chats/
	•	Description: Creates a new chat for an existing connection.
	•	Flow:
	•	Checks if a valid connection exists between the two users.
	•	If a chat already exists, returns the existing chat details.
	•	Otherwise, creates a new chat and stores it in the database.
	•	Frontend Usage: Called when a user starts a new chat.
	2.	GET /api/chats/<int:user_id>/
	•	Description: Fetches all chats for a specific user with the most recent message.
	•	Flow:
	•	Queries the database for all chats where the user is user1 or user2.
	•	Sorts chats by the most recent timestamp.
	•	Includes the latest message in each chat for display.
	•	Frontend Usage: Displays the user’s recent chats on their chat page.
	3.	GET /api/chats/messages/<int:user1_id>/<int:user2_id>/
	•	Description: Fetches the message history between two users.
	•	Flow:
	•	Queries the database for messages in the chat between the two users.
	•	Returns up to 15 messages, sorted by timestamp (newest first).
	•	Frontend Usage: Displays the message history when a chat is opened.

    Recommendation-Related Endpoint

	1.	GET /recommendations/<int:user_id>
	•	Description: Returns recommended users for a specific user.
	•	Flow:
	•	Queries the database for users who are not already connected to the specified user.
	•	Uses factors such as shared interests, goals, and location to rank recommendations.
	•	Frontend Usage: Used to suggest new connections to the user.
"""
