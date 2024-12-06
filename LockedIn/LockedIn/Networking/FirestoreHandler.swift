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


class FirestoreHandler {
    // Handles everything to do with Firebase.
    
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
                let data = document.data()
                print("document1")
                guard let content = data["content"] as? String,
                      let senderId = data["senderId"] as? String,
                      let timeStamp = (data["timestamp"] as? Timestamp)?.dateValue() 
                else {
                    print("Failed to get required fields from Firebase database.")
                    return nil
                }
                
                let finalKind: MessageKind = .text(content)
                
                let sender = Sender(senderId: senderId, displayName: "") // display name not required for chat view!
                
                return Message(sender: sender, messageId: document.documentID, sentDate: timeStamp, kind: finalKind)
            } ?? []
            
            completion(.success(messages))
        }
    }
}
