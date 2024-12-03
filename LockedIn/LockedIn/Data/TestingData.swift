//
//  TestingData.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/2/24.
//

import UIKit

struct TestingData {
    static let users = [
        CompleteCardView(with: UserData(
            image: UIImage(named: "john-pork"),
            name: "John Pork",
            university: .brown,
            year: .junior,
            degree: .finance,
            crackedRating: 69,
            aboutMe: "I am a noob",
            internship: nil
        )),
        
        CompleteCardView(with: UserData(
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
            image: UIImage(named: "ye"),
            name: "Ye",
            university: .harvard,
            year: .senior,
            degree: .business,
            crackedRating: 99,
            aboutMe: "I am a noob",
            internship: nil
        )),
        
        CompleteCardView(with: UserData(
            image: UIImage(named: "diddy"),
            name: "Sean J. Combs",
            university: .cornell,
            year: .sophomore,
            degree: .softwareEngineering,
            crackedRating: 95,
            aboutMe: "I am a noob",
            internship: nil
        )),
    ]
}
