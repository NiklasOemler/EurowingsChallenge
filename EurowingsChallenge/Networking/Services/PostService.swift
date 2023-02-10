//
//  PostService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

protocol PostService {
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void)
    func getCommentsForPost(postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void)
}

class DefaultPostService: BaseApiService, PostService {
    
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        client.sendGetRequest(
            endPoint: JsonPlaceholderEndpoints.posts) { response in
                let result = self.decodeResponse([Post].self, from: response)
                completion(result)
            }
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
