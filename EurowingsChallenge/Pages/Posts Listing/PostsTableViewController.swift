//
//  PostsTableViewController.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 10.02.23.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class PostsTableViewController: UITableViewController {
    private var viewModel: any PostsViewModel
    
    private var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let reuseIdentifier = "postCell"
    
    private var disposeBag = Set<AnyCancellable>()
    
    // MARK: - Object Lifecycle
    init(viewModel: any PostsViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        view = UITableView(frame:.zero, style:.insetGrouped)
    }
    
    override func viewDidLoad() {
        setupTableView()
        bindViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchPosts()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - State Binding
    private func bindViewState() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] viewState in
                guard let self = self else { return }
                
                self.tableView.backgroundView = nil
                
                switch(viewState) {
                case is LoadingState:
                    let indicator = UIActivityIndicatorView()
                    indicator.startAnimating()
                    indicator.style = .large
                    self.tableView.backgroundView = indicator
                case let errorState as ErrorViewState:
                    let component = ErrorViewComponent(
                        viewState: errorState,
                        action: self.viewModel.fetchPosts
                    )
                    self.tableView.backgroundView = component
                case let postsState as PostsViewState:
                    self.title = postsState.title
                    self.posts = postsState.posts
                default:
                    break
                }
            })
            .store(in: &disposeBag)
    }
    
    // MARK: - UITableViewDatasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let post = posts[indexPath.row]
        
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = post.title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let postDetailViewModel = DefaultPostDetailViewModel(post: post)
        let hostingController = UIHostingController(
            rootView: PostDetailRootView(
                viewModel: postDetailViewModel
            )
        )

        navigationController?.pushViewController(hostingController, animated: true)
    }
}
