//
//  CodableObjects.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/5/24.
//

import Foundation


// MARK: - Codable Models
struct User: Codable {
    let id: String
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

struct Swipe: Codable {
    let id: Int
    let swiperId: Int
    let swipedId: Int
}

struct Connection: Codable {
    let id: Int
    let user1Id: Int
    let user2Id: Int
}

struct UserSwipes: Codable {
    let swipesInitiated: [Swipe]
    let swipesReceived: [Swipe]
}

struct ConnectionCheck: Codable {
    let connected: Bool
}

struct MessageCodable: Codable {
    let id: Int?
    let connectionId: Int
    let senderId: Int
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case connectionId = "connection_id"
        case senderId = "sender_id"
        case content
    }
}

struct ConnectionsResponse: Decodable {
    let connections: [ConnectionWithDetails]
}

struct ConnectionWithDetails: Codable {
    let connection: Connection
    let otherUser: User
    let latestMessage: MessageCodable?
    
    enum CodingKeys: String, CodingKey {
        case connection
        case otherUser = "other_user"
        case latestMessage = "latest_message"
    }
}
