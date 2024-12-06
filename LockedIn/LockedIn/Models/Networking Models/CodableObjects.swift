//
//  CodableObjects.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/5/24.
//

import Foundation

// MARK: - Codable Models
struct User: Codable {
    let id: Int
    let linkedinUrl: String
    var name: String
    var goals: String
    var interests: String
    var university: String
    var major: String
    var company: String
    var jobTitle: String
    var experience: String
    var location: String
    var profilePic: String?
    var crackedRating: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case linkedinUrl = "linkedin_url"
        case name
        case goals
        case interests
        case university
        case major
        case company
        case jobTitle = "job_title"
        case experience
        case location
        case profilePic = "profile_pic"
        case crackedRating = "cracked_rating"
    }
}

struct Connection: Codable {
    let id: Int
    let user1: User
    let user2: User
    let timestamp: String
}

struct Chat: Codable {
    let id: Int
    let user1: User
    let user2: User
    let messages: [MessageCodable]
    let timestamp: String
}

struct MessageCodable: Codable {
    let id: Int
    let senderId: Int
    let content: String
    let timestamp: String
}
