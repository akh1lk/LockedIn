//
//  FirestoreHandler.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/6/24.
//

import UIKit
import MessageKit
import FirebaseFirestore
import FirebaseCore

/// Handles everything to do with Firebase.
class FirestoreHandler {
    
    // Used to register, sign in, sign out, and check authentication for the user.
    let constantToNeverTouch: Void = FirebaseApp.configure()
    public static let shared = FirestoreHandler()
    private let db = Firestore.firestore()
    
    private init() {}
    
    /// Returns all messages for a conversation given a taskUID (which is the convo UID).
    public func returnAllMessages(for connectionId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let storageRef = db
            .collection("chats")
            .document(connectionId)
            .collection("messages")
        
        storageRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let messages: [Message] = querySnapshot?.documents.compactMap { document in
                return Utils.createMessage(from: document.data())
            } ?? []
            
            completion(.success(messages))
        }
    }
    
    /// Sends a message to the firestore database.
    public func sendMessage(for connectionId: String, with message: Message, completion: @escaping (Bool) -> Void) {
            let messageData: [String: Any] = [
                "content": message.getText(),
                "senderId": message.sender.senderId,
                "timestamp": Timestamp(date: message.sentDate),
            ]
        
        let storageRef = db
            .collection("chats")
            .document(connectionId)
            .collection("messages")
            
            storageRef.addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
}
