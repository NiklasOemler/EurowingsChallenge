//
//  PostDetailTests.swift
//  EurowingsChallengeTests
//
//  Created by Niklas Oemler on 12.02.23.
//

import XCTest
import Combine

@testable import EurowingsChallenge

final class PostDetailTests: XCTestCase {
    
    private var post: Post!
    private var sut: (any PostDetailViewModel)!
    private var disposeBag: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        post = MockProvider.post
        sut = SpyPostDetailsViewModel(post: post)
        disposeBag = []
    }
    
    override func tearDownWithError() throws {
        post = nil
        sut = nil
        disposeBag = nil
    }
    
    func test_fetchDetails() {
        sut.fetchDetails()
        
        if let spy = sut as? SpyPostDetailsViewModel {
            let flag = spy.hasFetchedDetails
            XCTAssertTrue(flag, "viewmodel didnt invoked fetch posts function")
        }
    }
    
    func test_stateChanged_after_fetch() {
        let expectation = XCTestExpectation(description: "publisher finished")
        
        let initialState: ViewState = sut.viewState
        var lastState: ViewState?
        
        var states: [ViewState] = []
        
        if let spy = sut as? SpyPostDetailsViewModel {
            spy.$viewState
                .sink { state in
                    print("new state: \(state.self)")
                    
                    states.append(state)
                    lastState = state
                    
                    if !(lastState is LoadingState) {
                        expectation.fulfill()
                    }
                }
                .store(in: &disposeBag)
            
            spy.fetchDetails()
            
            wait(for: [expectation], timeout: 5)
            XCTAssertNotNil(lastState, "viewmodel didnt set new state after fetching posts")
        }
    }
}
