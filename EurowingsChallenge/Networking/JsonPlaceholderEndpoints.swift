//
//  Endpoints.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

enum JsonPlaceholderEndpoints {
    static let posts = "posts"
    static let users = "users"
    static let comments = "comments"
}


extension String {
    func appendingPathComponent(component: String) -> String {
        return appending("/").appending(component)
    }
}
