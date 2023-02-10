//
//  HttpClient.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

protocol HttpClient {
    func sendGetRequest(endPoint: String, completion: @escaping (ResponseStatus) -> Void)
}

enum ResponseStatus {
    case failure(error: Error)
    case success(data: Data)
}

class DefaultHttpClient {
    private let apiConfig: ApiConfig
    private let baseUrl: URL
    private let urlSession = URLSession.shared
    
    init(apiConfig: ApiConfig) {
        self.apiConfig = apiConfig
        
        let basePath = apiConfig.scheme + "://" + apiConfig.host
        self.baseUrl = URL(string: basePath)!
    }
    
    func sendGetRequest(endPoint: String, completion: @escaping (ResponseStatus) -> Void) {
        let url = baseUrl.appending(component: endPoint)
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error: error))
            }
            if let data {
                completion(.success(data: data))
            }
        }
    }
}
