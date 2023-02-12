//
//  ErrorViewComponent.swift
//  EurowingsChallenge
//
//  Created by Niklas Oemler on 11.02.23.
//

import Foundation
import UIKit
import SwiftUI

class ErrorViewComponent: UIView {
    var viewState: ErrorViewState {
        didSet {
            setState(viewState)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private let action: () -> Void
    
    // MARK: - Object Lifecycle
    required init(viewState: ErrorViewState, action: @escaping() -> Void) {
        self.viewState = viewState
        self.action = action
        super.init(frame: .zero)
        
        addSubViews()
        setState(viewState)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(button)
    }
    
    // MARK: - States
    private func setState(_ viewState: ErrorViewState) {
        titleLabel.text = viewState.title
        descriptionLabel.text = viewState.description
        button.setTitle(viewState.buttonTitle, for: .normal)
        
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTap() {
        action()
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

struct ErrorViewComponentRepresentable: UIViewRepresentable {
    typealias UIViewType = ErrorViewComponent
    
    private let viewState: ErrorViewState
    private let action: () -> Void
    
    init(viewState: ErrorViewState, action: @escaping () -> Void) {
        self.viewState = viewState
        self.action = action
    }
    
    func makeUIView(context: Context) -> ErrorViewComponent {
        return ErrorViewComponent(viewState: viewState, action: action)
    }
    
    func updateUIView(_ uiView: ErrorViewComponent, context: Context) {
        // NO - OP
    }
}
