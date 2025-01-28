# LockedIn
The Tinder for LinkedIn, swipe to network!
**[Watch Demo Video Here!]([url](https://youtu.be/SzN27DizuoQ?si=nk78sZSSL3G4CcpU))** 

## Screenshots:
<img src="https://github.com/user-attachments/assets/2d884bd1-090b-47bc-8d8f-d3a1c9a98274" width="720">
<br>
<img src="https://github.com/user-attachments/assets/d647767d-13e1-47cb-b0f8-8edb040209b4" width="180" height="346">
<img src="https://github.com/user-attachments/assets/c099db33-ace4-4f81-b98f-c130fa7e1e3d" width="180" height="346">
<img src="https://github.com/user-attachments/assets/b794dc21-8c30-451d-8aad-a2431165730f" width="180" height="346">
<img src="https://github.com/user-attachments/assets/13783849-56fa-477f-8930-729b498706ed" width="180" height="346">

## Description:
LinkedIn networking is boring. Nowadays people just want to waste away their time at their phones on apps like Tiktok, Tinder, Netflix, etc. Well what if we told you, you can network while wasting away at your phone! Swipe right if you want to network with an individual, left if you don't. Match with people that want to network with you too! Trust us, this connection is significantly more intimate than the ones you make through dry messaging on LinkedIn, and on top of that, using our app is just fun and addictive!

### Frontend (iOS):
- Multiple Screens: You can navigate between the Home page, Chat page, and Settings page (they are all part of a TabBarController). The chat and settings are both Navigation Controllers that present other screens.
- Scroll View: The full info view you see by clicking on the arrow on a given person is a vertical scroll view (that actually has horizontal scroll views embeded in it for the Interests and Career goals of an individual).
- Networking: We fetch all the people presented in your home screen from our back end API. Whenever you create your account your data is uploaded to the API.

### Backend - Routes:
- GET routes: fetch all users, fetch a single user, fetch connections, fetch swipes, fetch messages.
- POST routes: create a user, update a user's profile, create a swipe, create a connection, send a message.
- DELETE routes: delete a user, delete a connection, delete a swipe.
- Recommendation Algorithm: suggests users based on preferences and compatibility.

### Backend - Classes:
- Users: stores user information, one-to-one relationship with profile pictures via the Asset table.
- Swipes: represents swipe actions, one-to-many relationships with users (initiated and received swipes).
- Connections: represents mutual matches, many-to-many relationships between users, one-to-many with messages.
- Messages: stores chat messages, one-to-many with connections and many-to-one with senders.
- Assets: stores user profile pictures, one-to-one relationship with users.
