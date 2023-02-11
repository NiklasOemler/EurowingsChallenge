//
//  PostDetailViewModel.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation
import Combine

protocol PostDetailViewModel: ObservableObject {
    var viewState: ViewState { get set } // force @published wrapper or use subject ?
    
    func fetchDetails()
    func toggleComments()
}

class DefaultPostDetailViewModel: PostDetailViewModel {
    @Published var viewState: ViewState = LoadingState()
    
    private let postService: PostService = DefaultPostService(
        client: DefaultHttpClient()
    )
    
    private let userService: UserService = DefaultUserService(
        client: DefaultHttpClient()
    )
    
    private let post: Post
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(post: Post) {
        self.post = post
    }
    
    func fetchDetails() {
        viewState = LoadingState()
        
        let userPublisher = userService.getUser(id: post.userId)
        let commentsPublisher = postService.getCommentsForPost(postId: post.id)
        
        Publishers.Zip(userPublisher, commentsPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                print("completion called in \(self): \(completion)")
                if completion is any Error {
                    self.viewState = DefaultErrorViewState()
                }
            } receiveValue: { (user, comments) in
                let state = DefaultPostDetailViewState(
                    post: self.post,
                    author: user,
                    comments: comments
                )
                self.viewState = state
            }
            .store(in: &disposeBag)
    }
    
    func toggleComments() {
        if var state = viewState as? PostDetailViewState {
            state.showComments.toggle()
            self.viewState = state
        }
    }
}

