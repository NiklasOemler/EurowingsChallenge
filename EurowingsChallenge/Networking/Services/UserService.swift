//
//  UserService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

protocol UserService {
    func getUser(id: Int, completion: @escaping (User?) -> Void)
}

class DefaultUserService: BaseApiService, UserService {
    
    func getUser(id: Int, completion: @escaping (User?) -> Void) {
        let endpoint = JsonPlaceholderEndpoints.users
            .appendingPathComponent(
                component: String(id)
            )
        
        client.sendGetRequest(
            endPoint: endpoint) { response in
                switch(response) {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
