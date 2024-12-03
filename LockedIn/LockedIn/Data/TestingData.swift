//
//  TestingData.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/2/24.
//

import UIKit

struct TestingData {
    
    static let messages = [
        Message(sender: Sender(avatar: UIImage(named: "ye"), senderId: "user1", displayName: "John Pork"), messageId: "1", sentDate: Date(), kind: .text("Hello there!")),
        Message(sender: Sender(avatar: UIImage(named: "diddy"), senderId: "user2", displayName: "Jane Doe"), messageId: "2", sentDate: Date().addingTimeInterval(-3600), kind: .text("Hi, how can I help you?")),
    ]
    
    static let users = [
        CompleteCardView(with: UserData(
            id: "hello",
            image: UIImage(named: "john-pork"),
            name: "John Pork",
            university: .brown,
            year: .junior,
            degree: .finance,
            crackedRating: 69,
            aboutMe: "I am a noob LockedIn is just Tinder for LinkedIn. People connect their linkedin to form their profiles and get assigned a “Cracked Rating”. In the home screen of the app you are presented with a specific profile and get to swipe right to “like” or left to “skip”. If the person you swiped right ",
            internship: nil
        )),
        
        CompleteCardView(with: UserData(
            id: "hello1",
            image: UIImage(named: "andy"),
            name: "Andrew Myers",
            university: .harvard,
            year: .sophomore,
            degree: .computerScience,
            crackedRating: 999,
            aboutMe: "I am a noob",
            internship: nil
        )),
        
        CompleteCardView(with: UserData(
            id: "hello2",
            image: UIImage(named: "daddy-noel"),
            name: "Daddy Noel",
            university: .mit,
            year: .freshmen,
            degree: .business,
            crackedRating: 100,
            aboutMe: "I am a noob",
            internship: nil
        )),
        
        CompleteCardView(with: UserData(
            id: "hello3",
            image: UIImage(named: "ye"),
            name: "Ye",
            university: .dropout,
            year: .senior,
            degree: .business,
            crackedRating: 99,
            aboutMe: "I am a noob",
            internship: nil
        )),
        
        CompleteCardView(with: UserData(
            id: "hello4",
            image: UIImage(named: "diddy"),
            name: "Sean J. Combs",
            university: .cornell,
            year: .sophomore,
            degree: .softwareEngineering,
            crackedRating: 95,
            aboutMe: "Lorem ipsum odor amet, consectetuer adipiscing elit. Porttitor natoque sem turpis pretium dictumst eget suspendisse. Aad aliquam quam duis donec dictum eros. Molestie bibendum fringilla tortor fringilla netus fermentum lectus libero. Faucibus urna vehicula iaculis urna consequat duis elementum non. ",
            internship: Internship(company: "Amazon", position: "Software Engineer", date: "Summer dady")
        )),
    ]
}
