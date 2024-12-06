//
//  TestingData.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/2/24.
//

import UIKit

struct TestingData {
    
    static let messages = [
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe"), messageId: "1", sentDate: Date().addingTimeInterval(-3800), kind: .text("Hi, how can I help you?")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe"), messageId: "2", sentDate: Date().addingTimeInterval(-3600), kind: .text(" bot?")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe"), messageId: "3", sentDate: Date().addingTimeInterval(-3500), kind: .text(" nope")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe"), messageId: "4", sentDate: Date().addingTimeInterval(-3000), kind: .text(" gau")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe"), messageId: "5", sentDate: Date().addingTimeInterval(-2900), kind: .text("sup")),
        
    ]
    static let users: [CompleteCardView] = [
        CompleteCardView(with: User(
            id: 1,
            linkedinUrl: "https://www.linkedin.com/in/johndoe",
            name: "John Doe",
            goals: "Internships, Networking",
            interests: "Running, Photography",
            university: "Harvard University",
            major: "Computer Science",
            company: "Tech Corp",
            jobTitle: "Software Engineer",
            experience: "3 years in iOS Development",
            location: "New York, NY",
            profilePic: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwDQHT5oov3SMUPTN0rbWUc4t1BG5jyEpM3Q&s",
            crackedRating: "4.5"
        )),
        
        CompleteCardView(with: User(
            id: 2,
            linkedinUrl: "https://www.linkedin.com/in/janedoe",
            name: "Jane Doe",
            goals: "Start-ups, Upskilling",
            interests: "Dance, Swimming",
            university: "Stanford University",
            major: "Electrical Engineering",
            company: "Innovate Inc.",
            jobTitle: "Product Manager",
            experience: "5 years in Product Management",
            location: "San Francisco, CA",
            crackedRating: "4.8"
        )),
        
        CompleteCardView(with: User(
            id: 3,
            linkedinUrl: "https://www.linkedin.com/in/smithjohn",
            name: "Smith John",
            goals: "Mentor, Research",
            interests: "Tennis, Painting",
            university: "MIT",
            major: "Mechanical Engineering",
            company: "NextGen Robotics",
            jobTitle: "Mechanical Engineer",
            experience: "7 years in Robotics Engineering",
            location: "Boston, MA",
            crackedRating: "4.2"
        )),
    ]
}
