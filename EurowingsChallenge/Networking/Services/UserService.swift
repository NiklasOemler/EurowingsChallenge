//
//  UserService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation
import Combine

protocol UserService {
    func getUser(id: Int) -> AnyPublisher<User, Error>
    func getUser(id: Int, completion: @escaping (Result<User, Error>) -> Void)
}

class DefaultUserService: BaseApiService, UserService {
    
    func getUser(id: Int) -> AnyPublisher<User, Error> {
        let endpoint = JsonPlaceholderEndpoints.users
            .appendingPathComponent(
                component: String(id)
            )
        
        return client.sendGetRequest(endPoint: endpoint)
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getUser(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = JsonPlaceholderEndpoints.users
            .appendingPathComponent(
                component: String(id)
            )
        
        client.sendGetRequest(
            endPoint: endpoint) { response in
                let result = self.decodeResponse(User.self, from: response)
                completion(result)
            }
    }
}
