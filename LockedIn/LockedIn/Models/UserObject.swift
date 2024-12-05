//
//  UserCardData.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/1/24.
//

import UIKit
import MessageKit

struct UserObject {
    let id: String
    let image: UIImage?
    let name: String
    let university: University
    let year: Year
    let degree: Degree
    let crackedRating: Int
    let aboutMe: String
    
    let internship: Internship?
}
