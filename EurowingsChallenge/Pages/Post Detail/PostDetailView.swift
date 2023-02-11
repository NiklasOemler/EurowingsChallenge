//
//  PostDetailView.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation
import SwiftUI

struct PostDetailView<ViewModel: PostDetailViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        if let state = viewModel.viewState as? PostDetailViewState {
            VStack(spacing: 10) {
                Text(state.post.title)
                Text(state.post.body)
                Text(state.author.name)
                Button {
                    viewModel.toggleComments()
                } label: {
                    HStack() {
                        Image(systemName: "bubble.left")
                        Text("comments")
                        Image(systemName: state.showComments ? "chevron.up" : "chevron.down")
                    }
                    .onTapGesture {
                        viewModel.toggleComments()
                    }
                }
                if state.showComments {
                    List(state.comments) { item in
                        VStack {
                            Text(item.name)
                            Text(item.body)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchDetails()
            }
        }
    }
}


// MARK: - Previews
struct PostDetailView_previews: PreviewProvider {
    static let post: Post = MockProvider.post
    static let viewModel = DefaultPostDetailViewModel(post: post)
    
    static var previews: some View {
        
        VStack {
            PostDetailView(viewModel: viewModel)
        }
    }
}
