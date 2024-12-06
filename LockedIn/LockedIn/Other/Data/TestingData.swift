//
//  TestingData.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/2/24.
//

import UIKit

struct TestingData {
    
    static let messages = [
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe", crackedRating: 69), messageId: "1", sentDate: Date().addingTimeInterval(-3800), kind: .text("Hi, how can I help you?")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe", crackedRating: 69), messageId: "2", sentDate: Date().addingTimeInterval(-3600), kind: .text(" bot?")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe", crackedRating: 69), messageId: "3", sentDate: Date().addingTimeInterval(-3500), kind: .text(" nope")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe", crackedRating: 69), messageId: "4", sentDate: Date().addingTimeInterval(-3000), kind: .text(" gau")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe", crackedRating: 69), messageId: "5", sentDate: Date().addingTimeInterval(-2900), kind: .text("sup")),
        
    ]
    
    static let users: [CompleteCardView] = []
}
