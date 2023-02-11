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
    
    private let service: PostService = DefaultPostService(
        client: DefaultHttpClient()
    )
    
    private var disposeBag = Set<AnyCancellable>()
    
    func fetchPosts() {
        viewState.send(LoadingState())
        
        service.getPosts()
            .sink { completion in
                print("completion called in vm: \(completion)")
                if completion is any Error {
                    self.viewState.send(DefaultErrorViewState())
                }
            } receiveValue: { posts in
                let state = DefaultPostsViewState(posts: posts)
                self.viewState.send(state)
            }
            .store(in: &disposeBag)
    }
}
