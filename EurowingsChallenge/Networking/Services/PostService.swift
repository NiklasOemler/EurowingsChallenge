//
//  PostService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation
import Combine

protocol PostService {
    func getPosts() -> AnyPublisher<[Post], Error>
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void)
    
    func getCommentsForPost(postId: Int) -> AnyPublisher<[Comment], Error>
    func getCommentsForPost(postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void)
}

class DefaultPostService: BaseApiService, PostService {
    
    func getPosts() -> AnyPublisher<[Post], Error> {
        let endPoint = JsonPlaceholderEndpoints.posts
        return client.sendGetRequest(endPoint: endPoint)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        client.sendGetRequest(
            endPoint: JsonPlaceholderEndpoints.posts
        ) { response in
            let result = self.decodeResponse([Post].self, from: response)
            completion(result)
        }
    }
    
    func getCommentsForPost(postId: Int) -> AnyPublisher<[Comment], Error> {
        let endpoint = JsonPlaceholderEndpoints.posts
            .appendingPathComponent(component: String(postId))
            .appendingPathComponent(component: JsonPlaceholderEndpoints.comments)
        
        return client.sendGetRequest(endPoint: endpoint)
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getCommentsForPost(postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let endpoint = JsonPlaceholderEndpoints.posts
            .appendingPathComponent(component: String(postId))
            .appendingPathComponent(component: JsonPlaceholderEndpoints.comments)
        
        client.sendGetRequest(
            endPoint: endpoint) { response in
                let result = self.decodeResponse([Comment].self, from: response)
                completion(result)
            }
    }
}
