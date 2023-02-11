//
//  PostsViewState.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation

protocol PostsViewState: ViewState {
    var title: String { get }
    var posts: [Post] { get }
}

struct DefaultPostsViewState: PostsViewState {
    var title = "Posts"
    var posts: [Post]
}
