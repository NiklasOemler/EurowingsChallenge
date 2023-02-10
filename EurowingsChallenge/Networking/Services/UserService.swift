//
//  UserService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

protocol UserService {
    func getUser(id: Int, completion: @escaping (Result<User, Error>) -> Void)
}

class DefaultUserService: BaseApiService, UserService {
    
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
