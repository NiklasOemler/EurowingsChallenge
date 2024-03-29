//
//  PostsListingTests.swift
//  EurowingsChallengeTests
//
//  Created by Niklas Oemler on 12.02.23.
//

import XCTest
import Combine

@testable import EurowingsChallenge

final class PostsListingTests: XCTestCase {
    
    private var sut: (any PostsViewModel)!
    
    private var disposeBag: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        sut = SpyPostsViewModel()
        disposeBag = []
    }
    
    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
    }
    
    func test_fetchPosts() {
        sut.fetchPosts()
        
        if let spy = sut as? SpyPostsViewModel {
            let flag = spy.hasFetchedPosts
            XCTAssertTrue(flag, "viewmodel didnt invoked fetch posts function")
        }
    }
    
    func test_stateChanged_after_fetch() {
        let expectation = XCTestExpectation(description: "publisher finished")
    
        var lastState: ViewState?
        
        sut.viewState
            .sink { state in
                print("new state: \(state.self)")
    
                lastState = state
                
                if !(state is LoadingState) {
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        sut.fetchPosts()
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(lastState, "viewmodel didnt set new state after fetching posts")
    }
}
