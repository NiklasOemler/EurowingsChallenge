//
//  PostService.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

protocol PostService {
    func getPosts(completion: @escaping ([Post]?) -> Void)
    func getCommentsForPost(postId: Int, completion: @escaping ([Comment]?) -> Void)
}

class DefaultPostService: BaseApiService, PostService {
    
    func getPosts(completion: @escaping ([Post]?) -> Void) {
        client.sendGetRequest(
            endPoint: JsonPlaceholderEndpoints.posts) { response in
                switch (response) {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getCommentsForPost(postId: Int, completion: @escaping ([Comment]?) -> Void) {
        let endpoint = JsonPlaceholderEndpoints.posts
            .appendingPathComponent(component: String(postId))
            .appendingPathComponent(component: JsonPlaceholderEndpoints.comments)
        
        client.sendGetRequest(
            endPoint: endpoint) { response in
                switch (response) {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
