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
    let linkedinUsername: String
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
