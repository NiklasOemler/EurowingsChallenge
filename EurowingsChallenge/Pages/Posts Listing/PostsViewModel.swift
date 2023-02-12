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
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                print("completion called in \(self): \(completion)")
                if completion is any Error {
                    self.viewState.send(DefaultErrorViewState())
                }
            } receiveValue: { [weak self] posts in
                guard let self = self else { return }
                
                let state = DefaultPostsViewState(posts: posts)
                self.viewState.send(state)
            }
            .store(in: &disposeBag)
    }
}
