//
//  PostDetailView.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation
import SwiftUI

struct PostDetailRootView<ViewModel: PostDetailViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    @ViewBuilder
    var body: some View {
        Group {
            switch(viewModel.viewState) {
            case is LoadingState:
                ProgressView()
            case let errorState as ErrorViewState:
                ErrorViewComponentRepresentable(
                    viewState: errorState,
                    action: viewModel.fetchDetails
                )
            case let postDetailState as PostDetailViewState:
                PostDetailView(
                    viewModel: viewModel,
                    state: postDetailState
                )
            default:
                VStack {}
            }
        }.onAppear {
            viewModel.fetchDetails()
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
    }
}

struct PostDetailView<ViewModel: PostDetailViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    let state: PostDetailViewState
    
    var body: some View {
        VStack(spacing: 10) {
            Text(state.post.title)
            Text(state.post.body)
            Text(state.author.name)
            Button {
                withAnimation {
                    viewModel.toggleComments()
                }
            } label: {
                HStack() {
                    Image(systemName: "bubble.left")
                    Text(state.showComments ? "Hide Comments" : "Show Comments")
                    Image(systemName: state.showComments ? "chevron.up" : "chevron.down")
                }
            }
            if state.showComments {
                List(state.comments) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .bold()
                        Text(item.body)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        Spacer()
    }
}


// MARK: - Previews
struct PostDetailView_previews: PreviewProvider {
    static let post: Post = MockProvider.post
    static let viewModel = DefaultPostDetailViewModel(post: post)
    
    static var previews: some View {
        VStack {
            PostDetailRootView(
                viewModel: viewModel
            )
        }
    }
}
