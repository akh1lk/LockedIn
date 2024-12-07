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
    
    // MARK: - Recommendations
    func getUserRecommendations(userId: Int, maxResults: Int = 10, completion: @escaping (Result<[User], AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/\(userId)/recommendations/"
        
        // Add the max_results parameter to the request URL if it's greater than the default value
        var parameters: [String: Any] = [:]
        if maxResults != 10 {
            parameters["max_results"] = maxResults
        }

        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonResponse):
                do {
                    let recommendationsResponse = try JSONDecoder().decode(RecommendationsResponse.self, from: response.data ?? Data())
                    completion(.success(recommendationsResponse.recommendations))
                } catch let decodeError {
                    completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    
    // MARK: - User Endpoints
    func checkUser(firebaseId: String, completion: @escaping (Int) -> Void) {
        let url = "\(baseUrl)/api/users/\(firebaseId)"
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                if let rawResponse = String(data: data, encoding: .utf8) {
                    if rawResponse.contains("\"error\":") {
                        completion(-1)
                    } else {
                        if let userId = self.parseUserId(from: rawResponse) {
                            completion(Int(userId))
                        } else {
                            completion(-1)
                        }
                    }
                }
            } else if let error = response.error {
                completion(-1)
            }
        }
    }
    
    // I had to manually create a string parser because for the life of me I cannot use the decodable method.
    func parseUserId(from response: String) -> Int? {
        if let range = response.range(of: "\"user\": {") {
            let subResponse = String(response[range.upperBound...])
            
            if let idRange = subResponse.range(of: "\"id\":") {
                let idSubstring = subResponse[idRange.upperBound...]
                let idEndRange = idSubstring.range(of: ",")
                let idString = idSubstring[..<idEndRange!.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let id = Int(idString) {
                    return id
                }
            }
        }
        return nil
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
    
    func createUser(user: User, completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "\(baseUrl)/api/users/"
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: User.self) { response in
                // Debug print for the full response
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                }

                completion(response.result)
            }
    }
    
    func updateUser(id: Int, user: User, completion: @escaping (Result<User, AFError>) -> Void) {
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
        
        AF.request(url, method: .get).responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON response: \(jsonString)")
                    }
                    
                    do {
                        let connectionsResponse = try JSONDecoder().decode(ConnectionsResponse.self, from: data)
                        completion(.success(connectionsResponse.connections))
                    } catch let decodeError {
                        print("Decoding error: \(decodeError)")
                        completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                    }
    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(.failure(error))
                }
            }
        
        /*
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let jsonResponse):
                // Print out the top-level response
                if let json = jsonResponse as? [String: Any] {
                    print("JSON response: \(json)")
                    
                    // Check for the connections array
                    if let connections = json["connections"] as? [[String: Any]] {
                        print("Connections array: \(connections)")
                        
                        // Check each connection object
                        for connection in connections {
                            print("Connection: \(connection)")
                            
                            // Print each field in the ConnectionWithDetails object
                            for (key, value) in connection {
                                print("Key: \(key), Value: \(value)")
                            }
                        }
                    }
                }
                
                // Now try to decode the response into the ConnectionsResponse struct
                do {
                    let connectionsResponse = try JSONDecoder().decode(ConnectionsResponse.self, from: response.data ?? Data())
                    completion(.success(connectionsResponse.connections))
                } catch let decodeError {
                    print("Decoding error: \(decodeError)")
                    completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
         */
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
