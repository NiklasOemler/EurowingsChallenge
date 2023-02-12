//
//  PostDetailViewModel.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation
import Combine

protocol PostDetailViewModel: ObservableObject {
    var viewState: ViewState { get set }
    
    func fetchDetails()
    func toggleComments()
}

class DefaultPostDetailViewModel: PostDetailViewModel {
    @Published var viewState: ViewState = LoadingState()
    
    private var postService: PostService
    
    private var userService: UserService
    
    private let post: Post
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(
        post: Post,
        postService: PostService = DefaultPostService(client: DefaultHttpClient()),
        userService: UserService = DefaultUserService(client: DefaultHttpClient())
    ){
        self.post = post
        self.postService = postService
        self.userService = userService
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
                
                if case .failure(let error) = completion {
                    self.viewState = DefaultErrorViewState(error: error)
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

class SpyPostDetailsViewModel: DefaultPostDetailViewModel {
    var hasFetchedDetails: Bool = false
    
    override func fetchDetails() {
        super.fetchDetails()
        hasFetchedDetails = true
    }
}
