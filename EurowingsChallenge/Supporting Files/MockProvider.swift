//
//  MockProvider.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation

final class MockProvider {
    static let post: Post = Post(
        userId: Int.random(in: 1...10),
        id: Int.random(in: 0...10),
        title: "Mock Post Title",
        body: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia"
    )
    
    static let user: User = User(
        id: Int.random(in: 1...10),
        name: "Max Mustermann"
    )
    
    static let comments: [Comment] = [
        Comment(postId: Int.random(in: 1...10), id: Int.random(in: 1...10), name: "Mock Comment Title 1", body: "eirmod tempor invidunt ut labore et"),
        Comment(postId: Int.random(in: 1...10), id: Int.random(in: 1...10), name: "Mock Comment Title 2", body: "olore magna aliquyam erat, sed diam volu"),
        Comment(postId: Int.random(in: 1...10), id: Int.random(in: 1...10), name: "Mock Comment Title 3", body: "t ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolo")
    ]
}
