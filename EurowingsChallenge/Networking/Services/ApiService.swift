//
//  ApiService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

class BaseApiService {
    internal let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    internal func decodeResponse<T: Decodable>(_ type: T.Type, from response: Response) -> Result<T, Error> {
        switch(response) {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            } catch (let error) {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
