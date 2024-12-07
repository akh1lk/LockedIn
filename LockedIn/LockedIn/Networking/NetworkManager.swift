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
    
    public let baseUrl = "http://35.245.37.189"
    
    // MARK: - User Endpoints
    func checkUser(firebaseId: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseUrl)/api/user/\(firebaseId)"
        AF.request(url, method: .get).response { response in
            if response.error == nil, let data = response.data {
                // Check if the response contains the user
                if let responseObject = try? JSONDecoder().decode([String: String].self, from: data),
                   responseObject["message"] == "User exists" {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func loginLinkedIn(completion: @escaping (Result<String, AFError>) -> Void) {
        let url = "\(baseUrl)/login"
        AF.request(url, method: .get).responseString { response in
            completion(response.result)
        }
    }
    
    func authenticateLinkedIn(redirectURI: String, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/auth"
        let parameters: [String: Any] = ["redirect_uri": redirectURI]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseDecodable(of: User.self) { response in
                completion(response.result)
            }
    }
    
    func createOrUpdateUser(id: Int, user: User, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(id)/"
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: User.self) { response in
                // Debug print for the full response
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                }

                completion(response.result)
            }
    }
    
    func getUser(id: Int, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(id)/"
        AF.request(url, method: .get).responseDecodable(of: User.self) { response in
            completion(response.result)
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[User], AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/"
        AF.request(url, method: .get).responseDecodable(of: [User].self) { response in
            completion(response.result)
        }
    }
    
    // MARK: - Swipe Endpoints
    func createSwipe(swiperId: Int, swipedId: Int, completion: @escaping (Result<Swipe, AFError>) -> Void) {
        let url = "\(baseUrl)/api/swipes/"
        let parameters: [String: Any] = ["swiper_id": swiperId, "swiped_id": swipedId]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: Swipe.self) { response in
                completion(response.result)
            }
    }
    
    func getUserSwipes(userId: Int, completion: @escaping (Result<([Swipe], [Swipe]), AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(userId)/swipes/"
        AF.request(url, method: .get).responseDecodable(of: UserSwipes.self) { response in
            switch response.result {
            case .success(let swipes):
                completion(.success((swipes.swipesInitiated, swipes.swipesReceived)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Connection Endpoints
    func getUserConnections(userId: Int, completion: @escaping (Result<[ConnectionWithDetails], AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(userId)/connections/"
        AF.request(url, method: .get).responseDecodable(of: ConnectionsResponse.self) { response in
            switch response.result {
            case .success(let connectionsResponse):
                completion(.success(connectionsResponse.connections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkConnection(user1Id: Int, user2Id: Int, completion: @escaping (Result<Bool, AFError>) -> Void) {
        let url = "\(baseUrl)/api/connections/check/"
        let parameters: [String: Any] = ["user1_id": user1Id, "user2_id": user2Id]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseDecodable(of: ConnectionCheck.self) { response in
                completion(response.result.map { $0.connected })
            }
    }
    
    // MARK: - Messaging Endpoints
    func sendMessage(connectionId: Int, message: MessageCodable, completion: @escaping (Result<MessageCodable, AFError>) -> Void) {
        let url = "\(baseUrl)/api/connections/\(connectionId)/messages/"
        AF.request(url, method: .post, parameters: message, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: MessageCodable.self) { response in
                completion(response.result)
            }
    }
    
    func getConnectionMessages(connectionId: Int, completion: @escaping (Result<[MessageCodable], AFError>) -> Void) {
        let url = "\(baseUrl)/api/connections/\(connectionId)/messages/"
        AF.request(url, method: .get).responseDecodable(of: [MessageCodable].self) { response in
            completion(response.result)
        }
    }
}
