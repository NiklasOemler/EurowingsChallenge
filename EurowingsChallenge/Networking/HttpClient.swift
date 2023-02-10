//
//  HttpClient.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

protocol HttpClient {
    func sendGetRequest(endPoint: String, completion: @escaping (Response) -> Void)
}

typealias Response = Result<Data, Error>

class DefaultHttpClient: HttpClient {
    private let apiConfig: ApiConfig
    private let baseUrl: URL
    private let urlSession = URLSession.shared
    
    init(apiConfig: ApiConfig) {
        self.apiConfig = apiConfig
        
        let basePath = apiConfig.scheme + "://" + apiConfig.host
        self.baseUrl = URL(string: basePath)!
    }
    
    func sendGetRequest(endPoint: String, completion: @escaping (Response) -> Void) {
        let url = baseUrl.appending(component: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
    
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data {
                completion(.success(data))
            }
            if let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
