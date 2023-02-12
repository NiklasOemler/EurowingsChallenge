//
//  PostDetailViewState.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation

protocol PostDetailViewState: ViewState {
    var post: Post { get }
    var author: User { get }
    var comments: [Comment] { get }
    var showComments: Bool { get set }
}

struct DefaultPostDetailViewState: PostDetailViewState {
    var post: Post
    var author: User
    var comments: [Comment]
    var showComments: Bool = false
}

struct MockPostDetailViewState: PostDetailViewState {
    var post: Post = MockProvider.post
    var author: User = MockProvider.user
    var comments: [Comment] = MockProvider.comments
    var showComments: Bool = false
}
