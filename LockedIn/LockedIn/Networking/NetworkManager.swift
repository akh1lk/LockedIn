//
//  NetworkManager.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/5/24.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let baseUrl = "http://35.245.37.189"
    
    // MARK: - User Endpoints
    func createUser(_ user: User, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/"
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: User.self) { response in
                // Print the raw response for debugging
                if let data = response.data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
                }
                
                // Print any errors if present
                if let error = response.error {
                    print("Response Error: \(error.localizedDescription)")
                }
                
                // Pass the response result to the completion handler
                completion(response.result)
            }
    }
    
    func getUser(id: Int, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(id)/"
        AF.request(url, method: .get).responseDecodable(of: User.self) { response in
            completion(response.result)
        }
    }
    
    func updateUser(id: Int, user: User, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(id)/"
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: User.self) { response in
                completion(response.result)
            }
    }
    
    // MARK: - Connection Endpoints
    func createConnection(user1Id: Int, user2Id: Int, completion: @escaping (Result<Connection, AFError>) -> Void) {
        let url = "\(baseUrl)/api/connections/"
        let parameters: [String: Any] = ["user1_id": user1Id, "user2_id": user2Id]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: Connection.self) { response in
                completion(response.result)
            }
    }
    
    func getUserConnections(userId: Int, completion: @escaping (Result<[Connection], AFError>) -> Void) {
        let url = "\(baseUrl)/api/connections/\(userId)/"
        AF.request(url, method: .get).responseDecodable(of: [Connection].self) { response in
            completion(response.result)
        }
    }
    
    func deleteConnection(connectionId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseUrl)/api/connections/\(connectionId)"
        AF.request(url, method: .delete).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Chat Endpoints
    
    func createChat(user1Id: Int, user2Id: Int, completion: @escaping (Result<Chat, AFError>) -> Void) {
        let url = "\(baseUrl)/api/chats/"
        let parameters: [String: Any] = ["user1_id": user1Id, "user2_id": user2Id]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: Chat.self) { response in
                completion(response.result)
            }
    }
    
    func getUserChats(userId: Int, completion: @escaping (Result<[Chat], AFError>) -> Void) {
        let url = "\(baseUrl)/api/chats/\(userId)/"
        AF.request(url, method: .get).responseDecodable(of: [Chat].self) { response in
            completion(response.result)
        }
    }
    
    // MARK: - Message Endpoints
    func getChatMessages(user1Id: Int, user2Id: Int, completion: @escaping (Result<[MessageCodable], AFError>) -> Void) {
        let url = "\(baseUrl)/api/chats/messages/\(user1Id)/\(user2Id)/"
        AF.request(url, method: .get).responseDecodable(of: [MessageCodable].self) { response in
            completion(response.result)
        }
    }
}
