//
//  PostsViewModel.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation
import Combine

protocol PostsViewModel: ObservableObject {
    var viewState: CurrentValueSubject<ViewState, Never> { get set }
    
    func fetchPosts()
}

class DefaultPostsViewModel: PostsViewModel {
    var viewState = CurrentValueSubject<ViewState, Never>(LoadingState())
    
    private var service: PostService
    
    private var disposeBag = Set<AnyCancellable>()
    
    // MARK: - Objecte Lifecycle
    init(postService: PostService = DefaultPostService(client: DefaultHttpClient())) {
        self.service = postService
    }
    
    func fetchPosts() {
        viewState.send(LoadingState())
        
        service.getPosts()
            .sink { [weak self] completion in
                guard let self = self else { return }
                print("completion called in \(self): \(completion)")
                
                if case .failure(let error) = completion {
                    self.viewState.send(DefaultErrorViewState(error: error))
                }
            } receiveValue: { [weak self] posts in
                guard let self = self else { return }
                
                let state = DefaultPostsViewState(posts: posts)
                self.viewState.send(state)
            }
            .store(in: &disposeBag)
    }
}

class SpyPostsViewModel: DefaultPostsViewModel {
    var hasFetchedPosts: Bool = false
    
    override func fetchPosts() {
        super.fetchPosts()
        
        hasFetchedPosts = true
    }
}
