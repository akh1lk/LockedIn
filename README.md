# LockedIn
The Tinder for LinkedIn, swipe to network!

## Screenshots:
<img src="https://github.com/user-attachments/assets/11775e3b-6090-4b89-a8ef-4ecb798539f5" width="48">
![Simulator Screenshot - iPhone 15 Pro - 2024-12-04 at 18 57 52](https://github.com/user-attachments/assets/11775e3b-6090-4b89-a8ef-4ecb798539f5)
![image](https://github.com/user-attachments/assets/d647767d-13e1-47cb-b0f8-8edb040209b4)
![image](https://github.com/user-attachments/assets/c099db33-ace4-4f81-b98f-c130fa7e1e3d)
![image](https://github.com/user-attachments/assets/b794dc21-8c30-451d-8aad-a2431165730f)
![image](https://github.com/user-attachments/assets/13783849-56fa-477f-8930-729b498706ed)

## Description:
LinkedIn networking is dry and boring. Nowadays people just want to waste away their time at their phones on apps like Tiktok, Tinder, Netflix, etc. Well what if we told you, you can network while wasting away at your phone! Swipe right if you want to network with an individual, left if you don't. Match with people that want to network with you too! Trust us, this connection is significantly more intimate than the ones you make through dry messaging on LinkedIn, and on top of that, using our app is just fun and addictive!

## Meeting Requirements:
Frontend (iOS):
- Multiple Screens: You can navigate between the Home page, Chat page, and Settings page (they are all part of a TabBarController). The chat and settings are both Navigation Controllers that present other screens.
- Scroll View: The full info view you see by clicking on the arrow on a given person is a vertical scroll view (that actually has horizontal scroll views embeded in it for the Interests and Career goals of an individual).
- Networking: We fetch all the people presented in your home screen from our back end API. Whenever you create your account your data is uploaded to the API.

## Backend:
- 4 routes: GET for fetching users to present in the home screen, POST when creating a new user or updating a users profile, DELETE when deleting a connection between two users.
- 2 tables: chat and messages, one to many relationship. Also one to one relationships between users.
- API Specification: See the end of [this file](https://github.com/akh1lk/LockedIn/blob/main/LockedIn_Backend/src/app.py).
At least 2 tables in database with a relationship between them
API specification explaining each implemented route

## Notes for Grader:
- This app was a bit challenging, and unforutnately Akhil's account got suspended after publicly posting his Amazon Web Services API key when making this repo public. We have submitted an appeal, but images may not be there for networking. 
