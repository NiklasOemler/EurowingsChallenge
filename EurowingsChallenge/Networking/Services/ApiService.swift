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
}
