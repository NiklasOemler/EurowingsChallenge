//
//  HttpClient.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation
import Combine

protocol HttpClient {
    func sendGetRequest(endPoint: String, completion: @escaping (Response) -> Void)
    func sendGetRequest(endPoint: String) -> AnyPublisher<Data, Error>
}

typealias Response = Result<Data, Error>

class DefaultHttpClient: HttpClient {
    private let urlSession = URLSession.shared
    private let apiConfig: ApiConfig
    private let baseUrl: String
    
    init(apiConfig: ApiConfig = ConfigProvider.sharedInstance.config.api) {
        self.apiConfig = apiConfig
        self.baseUrl = apiConfig.scheme + "://" + apiConfig.host
    }
    
    func sendGetRequest(endPoint: String, completion: @escaping (Response) -> Void) {
        let url = URL(string: baseUrl.appendingPathComponent(component: endPoint))
        var request = URLRequest(url: url!)
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
    
    func sendGetRequest(endPoint: String) -> AnyPublisher<Data, Error> {
        let url = URL(string: self.baseUrl.appendingPathComponent(component: endPoint))!
        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError {$0 as Error}
            .eraseToAnyPublisher()
    }
}
