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
                EmptyView()
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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(state.post.title)
                        .bold()
                    Text(state.post.body)
                    Text("Author: \(state.author.name)")
                        .padding(.top, 10)
                }
                Divider()
                    .padding(.top, 20)
                Button {
                    withAnimation {
                        viewModel.toggleComments()
                    }
                } label: {
                    HStack() {
                        Image(systemName: "bubble.left")
                        Text("Comments (\(state.comments?.count ?? 0))")
                        Image(systemName: state.showComments ? "chevron.up" : "chevron.down")
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 20)
                
                if let comments = state.comments,
                    state.showComments {
                    ForEach(comments) { item in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.name)
                                .bold()
                            Text(item.body)
                            Divider()
                                .padding(.vertical, 20)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}


// MARK: - Previews
struct PostDetailView_previews: PreviewProvider {
    
    @ObservedObject
    static var viewModel = MockPostDetailsViewModel()
    
    static var previews: some View {
        VStack {
            PostDetailRootView(
                viewModel: viewModel
            )
        }
    }
}
