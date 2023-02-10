//
//  Comment.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation

struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let body: String
}
